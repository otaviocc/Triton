import AuthSessionServiceInterface
import PURLsNetworkService
import PURLsPersistenceService
import SessionServiceInterface
import SwiftData

/// A repository protocol for managing Permanent URL (PURL) data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide PURL management functionality. It handles fetching PURLs from remote sources,
/// managing local storage through SwiftData, and coordinating CRUD operations for permanent URLs.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with PURL data. It automatically
/// manages the synchronization of PURL data through streaming mechanisms and coordinates
/// local and remote operations for consistent data management.
public protocol PURLsRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying PURLs.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// PURL collection changes. The container maintains the local cache of
    /// PURLs for the authenticated user.
    var purlsContainer: ModelContainer { get }

    /// Fetches PURLs for the currently authenticated user's address.
    ///
    /// This method coordinates the fetching of PURLs by:
    /// 1. Verifying the user is authenticated
    /// 2. Getting the current user's address from session
    /// 3. Requesting all PURLs from the remote server for that address
    /// 4. The PURLs are automatically stored locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation.
    func fetchPURLs() async throws

    /// Creates a new PURL on the remote server.
    ///
    /// This method coordinates the creation of a new PURL by:
    /// 1. Sending the PURL creation request to the remote server
    /// 2. The updated PURL collection is automatically fetched and stored locally
    ///    via the network service's automatic refresh mechanism
    ///
    /// The PURL name must be unique within the address and will serve as the
    /// permanent identifier for the redirect URL.
    ///
    /// - Parameters:
    ///   - address: The address where the PURL should be created.
    ///   - name: The unique name/identifier for the new PURL.
    ///   - url: The target URL that the PURL should redirect to.
    /// - Throws: Network errors, validation errors, or API errors if the creation fails.
    func addPURL(
        address: String,
        name: String,
        url: String
    ) async throws

    /// Deletes a PURL from both remote server and local storage for the specified address.
    ///
    /// This method coordinates the deletion of a PURL by:
    /// 1. Verifying the user is authenticated
    /// 2. Deleting the PURL from the remote server for the specified address
    /// 3. Removing the PURL from local storage
    ///
    /// The method handles both remote and local deletion to ensure data consistency.
    /// If the local deletion fails, an error is logged but the operation continues
    /// since the remote deletion was successful.
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address that owns the PURL.
    ///   - name: The name/identifier of the PURL to delete.
    /// - Throws: Network errors or authentication errors if the remote deletion fails.
    func deletePURL(
        address: String,
        name: String
    ) async throws
}

actor PURLsRepository: PURLsRepositoryProtocol {

    // MARK: - Properties

    nonisolated var purlsContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any PURLsNetworkServiceProtocol
    private let persistenceService: any PURLsPersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private var streamTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: any PURLsNetworkServiceProtocol,
        persistenceService: PURLsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        Task {
            await startPURLsSync()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    // MARK: - Public

    func fetchPURLs() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        try await networkService.fetchPURLs(
            for: current
        )
    }

    func addPURL(
        address: String,
        name: String,
        url: String
    ) async throws {
        try await networkService.addPURL(
            address: address,
            name: name,
            url: url
        )
    }

    func deletePURL(
        address: String,
        name: String
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.deletePURL(
            address: address,
            name: name
        )

        do {
            try await persistenceService.deletePURL(
                address: address,
                name: name
            )
        } catch {
            print("Failed to delete PURL from persistence: \(error)")
        }
    }

    // MARK: - Private

    private func startPURLsSync() {
        streamTask = Task { [weak self] in
            guard let self else { return }

            for await purls in networkService.purlsStream() {
                guard !Task.isCancelled else { break }

                guard
                    await authSessionService.isLoggedIn,
                    case let .address(current) = await sessionService.address
                else { continue }

                do {
                    let storablePurls = purls.map { purlResponse in
                        StorablePURL(
                            address: current,
                            purlResponse: purlResponse
                        )
                    }
                    try await persistenceService.storePURLs(purls: storablePurls)
                } catch {
                    print("Failed to persist PURLs: \(error)")
                }
            }
        }
    }
}
