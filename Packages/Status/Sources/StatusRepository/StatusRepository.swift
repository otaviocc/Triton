import AsyncAlgorithms
import Foundation
import StatusNetworkService
import StatusPersistenceService
import SwiftData

/// A repository protocol for managing status update data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide status timeline management. It handles fetching status updates from remote sources,
/// posting new status updates, and managing local storage through SwiftData.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with status data. It automatically
/// manages the continuous synchronization of status updates through streaming mechanisms
/// and coordinates posting operations with timeline refresh.
public protocol StatusRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying status updates.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// status timeline changes. The container maintains the local cache of
    /// status updates from the social network.
    var statusesContainer: ModelContainer { get }

    /// Posts a new status update to the network.
    ///
    /// This method coordinates the posting of a new status update by:
    /// 1. Sending the status update to the remote server via the network service
    /// 2. The new status will eventually appear in the timeline through the automatic
    ///    streaming mechanism that runs every 30 seconds
    ///
    /// The method only handles the posting operation; the timeline refresh happens
    /// automatically through the background streaming process.
    ///
    /// - Parameters:
    ///   - address: The user address posting the status update.
    ///   - emoji: The emoji icon to associate with the status for visual representation.
    ///   - content: The markdown-formatted content of the status update.
    /// - Throws: Network errors, authentication errors, or API validation errors if the post fails.
    func postStatus(
        address: String,
        emoji: String,
        content: String
    ) async throws

    /// Fetches the latest status updates immediately and stores them locally.
    ///
    /// This method performs an on-demand synchronization of the status timeline by:
    /// 1. Fetching the latest status updates from the remote server
    /// 2. Converting the network responses to storable format
    /// 3. Persisting the updates in local storage
    /// 4. Replacing any existing cached status data with the fresh updates
    ///
    /// Use this method when you need to refresh the timeline immediately,
    /// independent of the automatic 30-second streaming cycle.
    ///
    /// - Throws: Network errors from the remote fetch operation or persistence errors
    ///           from the local storage operations.
    func fetchStatuses() async throws

    /// Mutes a specific user address to filter their status updates from the timeline.
    ///
    /// This method adds a user address to the local mute list, which causes
    /// status updates from that user to be filtered out from timeline displays.
    /// The muted address is persisted locally and remains in effect until
    /// explicitly unmuted.
    ///
    /// - Parameter address: The user address to mute in the timeline.
    /// - Throws: Persistence errors if the mute operation fails to save locally.
    func muteAddress(address: String) async throws

    /// Unmutes a previously muted user address, allowing their status updates in the timeline.
    ///
    /// This method removes a user address from the local mute list, restoring
    /// visibility of their status updates in timeline displays. If the address
    /// was not previously muted, this operation has no effect.
    ///
    /// - Parameter address: The user address to unmute in the timeline.
    /// - Throws: Persistence errors if the unmute operation fails to save locally.
    func unmuteAddress(address: String) async throws

    /// Mutes a specific keyword to filter status updates containing that word from the timeline.
    ///
    /// This method adds a keyword to the local mute list, which causes
    /// status updates containing that keyword (case-insensitive) to be filtered
    /// out from timeline displays. The muted keyword is persisted locally and
    /// remains in effect until explicitly unmuted.
    ///
    /// - Parameter keyword: The keyword to mute in status update content.
    /// - Throws: Persistence errors if the mute operation fails to save locally.
    func muteKeyword(keyword: String) async throws

    /// Unmutes a previously muted keyword, allowing status updates containing that word in the timeline.
    ///
    /// This method removes a keyword from the local mute list, restoring
    /// visibility of status updates containing that keyword. If the keyword
    /// was not previously muted, this operation has no effect.
    ///
    /// - Parameter keyword: The keyword to unmute in status update content.
    /// - Throws: Persistence errors if the unmute operation fails to save locally.
    func unmuteKeyword(keyword: String) async throws
}

actor StatusRepository: StatusRepositoryProtocol {

    // MARK: - Properties

    nonisolated var statusesContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any StatusNetworkServiceProtocol
    private let persistenceService: any StatusPersistenceServiceProtocol
    private var streamTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: StatusNetworkServiceProtocol,
        persistenceService: StatusPersistenceServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService

        Task { await startStatusSync() }
    }

    deinit {
        streamTask?.cancel()
    }

    // MARK: - Public

    func postStatus(
        address: String,
        emoji: String,
        content: String
    ) async throws {
        try await networkService.postStatus(
            address: address,
            emoji: emoji,
            content: content
        )
    }

    func fetchStatuses() async throws {
        let statuses = try await networkService.fetchStatuses()
        let storableStatuses = statuses.map(StorableStatus.init)

        try await persistenceService.storeStatuses(
            statuses: storableStatuses
        )
    }

    func muteAddress(
        address: String
    ) async throws {
        try await persistenceService.muteAddress(
            address: address
        )
    }

    func unmuteAddress(
        address: String
    ) async throws {
        try await persistenceService.unmuteAddress(
            address: address
        )
    }

    func muteKeyword(
        keyword: String
    ) async throws {
        try await persistenceService.muteKeyword(
            keyword: keyword
        )
    }

    func unmuteKeyword(
        keyword: String
    ) async throws {
        try await persistenceService.unmuteKeyword(
            keyword: keyword
        )
    }

    // MARK: - Private

    private func startStatusSync() async {
        streamTask = Task { [weak self] in
            guard let self else { return }

            try? await fetchStatuses()

            for await _ in AsyncTimerSequence(interval: .seconds(30), clock: .continuous) {
                try? await fetchStatuses()
            }
        }
    }
}
