import AuthSessionServiceInterface
import Foundation
import NowNetworkService
import NowPersistenceService
import SessionServiceInterface
import SwiftData

/// A repository protocol for managing /now page data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide /now page management functionality. It handles fetching /now pages from remote
/// sources, managing local storage through SwiftData, and coordinating updates to personal
/// status content.
///
/// The /now page is a concept from nownownow.com where people share what they're currently
/// focused on in their lives. The repository follows the repository pattern, abstracting
/// data access and providing a clean interface for higher-level components to interact
/// with /now page data. It automatically manages the synchronization of /now page content
/// through streaming mechanisms.
public protocol NowRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying /now pages.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// /now page changes. The container maintains a limited history of /now page
    /// versions for the authenticated user.
    var nowContainer: ModelContainer { get }

    /// Fetches the current /now page for the authenticated user's address.
    ///
    /// This method coordinates between the network and persistence layers to:
    /// 1. Verify the user is authenticated
    /// 2. Get the current user's address from session
    /// 3. Request the latest /now page content from the remote server
    /// 4. The content is automatically stored locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation.
    func fetchNowPage() async throws

    /// Updates the /now page content for the specified address.
    ///
    /// This method coordinates a complete update cycle:
    /// 1. Verify the user is authenticated
    /// 2. Upload the new content to the remote server for the specified address with visibility settings
    /// 3. Fetch the updated content to get the new timestamp and confirm the update
    /// 4. Store the updated content locally via the streaming mechanism
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address for which to update the /now page content.
    ///   - content: The new markdown content for the /now page.
    ///   - isListed: Whether the /now page should be visible in public directories.
    /// - Throws: Network errors from the remote update or fetch operations.
    func updateNowPage(
        address: String,
        content: String,
        isListed: Bool
    ) async throws
}

actor NowRepository: NowRepositoryProtocol {

    // MARK: - Properties

    nonisolated var nowContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: NowNetworkServiceProtocol
    private let persistenceService: any NowPersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private var streamTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: NowNetworkServiceProtocol,
        persistenceService: NowPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        Task {
            await startNowPageSync()
        }
    }

    deinit {
        streamTask?.cancel()
    }

    // MARK: - Public

    func fetchNowPage() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        try await networkService.fetchNowPage(
            for: current
        )
    }

    func updateNowPage(
        address: String,
        content: String,
        isListed: Bool
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.updateNowPage(
            address: address,
            content: content,
            listed: isListed
        )

        try await fetchNowPage()
    }

    // MARK: - Private

    private func startNowPageSync() {
        streamTask = Task { [weak self] in
            guard let self else { return }

            for await nowResponse in networkService.nowStream() {
                guard !Task.isCancelled else { break }

                guard
                    await authSessionService.isLoggedIn,
                    case let .address(current) = await sessionService.address
                else { continue }

                do {
                    let storableNow = StorableNow(
                        address: current,
                        nowResponse: nowResponse
                    )

                    try await persistenceService.storeNowPage(nowPage: storableNow)
                } catch {
                    print("Failed to persist Now page: \(error)")
                }
            }
        }
    }
}
