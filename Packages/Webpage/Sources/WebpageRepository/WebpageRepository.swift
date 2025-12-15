import AuthSessionServiceInterface
import Foundation
import SessionServiceInterface
import SwiftData
import WebpageNetworkService
import WebpagePersistenceService

/// A repository protocol for managing webpage content data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide webpage content management. It handles fetching content from remote sources,
/// managing local storage through SwiftData, and coordinating real-time updates through
/// streaming mechanisms.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with webpage data. It automatically
/// manages the lifecycle of webpage content and ensures data consistency between local
/// and remote sources.
public protocol WebpageRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying webpage content.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// webpage content changes. The container manages webpage versioning
    /// and maintains a limited history of content changes.
    var webpageContainer: ModelContainer { get }

    /// Fetches the current webpage content for the authenticated user's address.
    ///
    /// This method coordinates between the network and persistence layers to:
    /// 1. Verify the user is authenticated
    /// 2. Get the current user's address from session
    /// 3. Request the latest webpage content from the remote server
    /// 4. The content is automatically stored locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation.
    func fetchWebpage() async throws

    /// Updates the webpage content for the specified address.
    ///
    /// This method coordinates a complete update cycle:
    /// 1. Verify the user is authenticated
    /// 2. Upload the new content to the remote server for the specified address
    /// 3. Fetch the updated content to get the new timestamp and confirm the update
    /// 4. Store the updated content locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address for which to update the webpage content.
    ///   - content: The new markdown content to publish.
    /// - Throws: Network errors from the remote update or fetch operations.
    func updateWebpage(
        address: String,
        content: String
    ) async throws
}

actor WebpageRepository: WebpageRepositoryProtocol {

    // MARK: - Properties

    nonisolated var webpageContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any WebpageNetworkServiceProtocol
    private let persistenceService: any WebpagePersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private var streamTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: any WebpageNetworkServiceProtocol,
        persistenceService: WebpagePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        Task {
            await startWebpageSync()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    // MARK: - Public

    func fetchWebpage() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        try await networkService.fetchWebpage(
            for: current
        )
    }

    func updateWebpage(
        address: String,
        content: String
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.updateWebpage(
            address: address,
            content: content
        )

        try await fetchWebpage()
    }

    // MARK: - Private

    private func startWebpageSync() {
        streamTask = Task { [weak self] in
            guard let self else { return }

            for await webResponse in networkService.webpageStream() {
                guard !Task.isCancelled else { break }

                guard
                    await authSessionService.isLoggedIn,
                    case let .address(current) = await sessionService.address
                else { continue }

                do {
                    let storableWebpage = StorableWebpage(
                        address: current,
                        webpage: webResponse
                    )
                    try await persistenceService.storeWebpage(webpage: storableWebpage)
                } catch {
                    print("Failed to persist webpage: \(error)")
                }
            }
        }
    }
}
