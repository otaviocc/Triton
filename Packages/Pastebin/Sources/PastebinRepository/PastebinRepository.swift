import AuthSessionServiceInterface
import PastebinNetworkService
import PastebinPersistenceService
import SessionServiceInterface
import SwiftData

/// A repository protocol for managing pastebin data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide pastebin functionality. It handles fetching pastes from remote sources,
/// managing local storage through SwiftData, and coordinating CRUD operations for text snippets.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with paste data. It automatically
/// manages the synchronization of paste data through streaming mechanisms and coordinates
/// local and remote operations for consistent data management.
public protocol PastebinRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying pastes.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// paste collection changes. The container maintains the local cache of
    /// pastes for the authenticated user.
    var pastebinContainer: ModelContainer { get }

    /// Fetches pastes for the currently authenticated user's address.
    ///
    /// This method coordinates the fetching of pastes by:
    /// 1. Verifying the user is authenticated
    /// 2. Getting the current user's address from session
    /// 3. Requesting all pastes from the remote server for that address
    /// 4. The pastes are automatically stored locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation.
    func fetchPastes() async throws

    /// Creates a new paste or updates an existing one on the remote server for the specified address.
    ///
    /// This method coordinates the creation or update of a paste by:
    /// 1. Verifying the user is authenticated
    /// 2. Sending the paste creation/update request to the remote server for the specified address
    /// 3. Fetching the updated paste collection to refresh local storage
    ///
    /// If a paste with the same title already exists, it will be updated with
    /// the new content and visibility settings. The method will silently return
    /// if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address for which to create or update the paste.
    ///   - title: The unique title/identifier for the paste.
    ///   - content: The text content of the paste.
    ///   - isListed: Whether the paste should be publicly visible (true) or private (false).
    /// - Throws: Network errors, validation errors, or API errors if the operation fails.
    func createOrUpdatePaste(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) async throws

    /// Deletes a paste from both remote server and local storage for the specified address.
    ///
    /// This method coordinates the deletion of a paste by:
    /// 1. Verifying the user is authenticated
    /// 2. Deleting the paste from the remote server for the specified address
    /// 3. Removing the paste from local storage
    ///
    /// The method handles both remote and local deletion to ensure data consistency.
    /// If the local deletion fails, an error is logged but the operation continues
    /// since the remote deletion was successful.
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address that owns the paste.
    ///   - title: The title/identifier of the paste to delete.
    /// - Throws: Network errors or authentication errors if the remote deletion fails.
    func deletePaste(
        address: String,
        title: String
    ) async throws
}

actor PastebinRepository: PastebinRepositoryProtocol {

    // MARK: - Properties

    nonisolated var pastebinContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any PastebinNetworkServiceProtocol
    private let persistenceService: any PastebinPersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private var streamTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: any PastebinNetworkServiceProtocol,
        persistenceService: PastebinPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        Task { await setUpObservers() }
    }

    deinit {
        streamTask?.cancel()
    }

    // MARK: - Public

    func fetchPastes() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        try await networkService.fetchPastes(
            for: current
        )
    }

    func createOrUpdatePaste(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.createOrUpdatePaste(
            address: address,
            title: title,
            content: content,
            listed: isListed
        )

        try await fetchPastes()
    }

    func deletePaste(
        address: String,
        title: String
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.deletePaste(
            address: address,
            title: title
        )

        await MainActor.run {
            do {
                try persistenceService.deletePaste(
                    address: address,
                    title: title
                )
            } catch {
                print("Failed to delete paste from persistence: \(error)")
            }
        }
    }

    // MARK: - Private

    private func setUpObservers() async {
        streamTask = Task { [weak self] in
            guard let self else { return }

            for await pastes in networkService.pastesStream() {
                guard !Task.isCancelled else { break }

                guard
                    await authSessionService.isLoggedIn,
                    case let .address(current) = await sessionService.address
                else { continue }

                do {
                    let storablePastes = pastes.map { pasteResponse in
                        StorablePaste(
                            address: current,
                            pasteResponse: pasteResponse
                        )
                    }
                    try await persistenceService.storePastes(pastes: storablePastes)
                } catch {
                    print("Failed to persist pastes: \(error)")
                }
            }
        }
    }
}
