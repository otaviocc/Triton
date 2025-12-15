import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing status update persistence operations.
///
/// This protocol defines the interface for local storage operations of status updates
/// using SwiftData. It handles storing timeline status data in the local database
/// and managing data cleanup when users log out.
///
/// The service maintains a cache of status updates from the social timeline, storing
/// the most recent status for each user (enforced by unique constraints on username).
/// This creates a "latest status per user" storage model rather than a complete history.
/// All mutation operations are constrained to the main actor to ensure thread safety
/// with SwiftData operations and UI updates.
public protocol StatusPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for status update persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to status timeline storage.
    /// The container handles unique constraints to maintain one status per user.
    var container: ModelContainer { get }

    /// Stores multiple status updates in the persistent container.
    ///
    /// This method processes an array of status updates and stores them in local storage.
    /// Each status update is identified by its associated username, and the unique
    /// constraints ensure that only the most recent status for each user is maintained.
    ///
    /// If a status for the same username already exists, it will be replaced with
    /// the new status data, maintaining a "current status per user" model rather
    /// than a complete timeline history.
    ///
    /// - Parameter statuses: An array of `StorableStatus` objects to store locally.
    /// - Throws: SwiftData persistence errors or validation errors during storage operations.
    @MainActor
    func storeStatuses(
        statuses: [StorableStatus]
    ) throws

    /// Stores a user address in the local mute list.
    ///
    /// This method creates a new `MutedAddress` entry in the SwiftData container,
    /// persisting the muted address locally. Status updates from this address will
    /// be filtered from timeline displays. The operation is performed on the main actor
    /// to ensure thread safety with SwiftData operations.
    ///
    /// - Parameter address: The user address to add to the mute list.
    /// - Throws: SwiftData persistence errors if the save operation fails.
    @MainActor
    func muteAddress(
        address: String
    ) throws

    /// Removes a user address from the local mute list.
    ///
    /// This method deletes the `MutedAddress` entry from the SwiftData container
    /// if it exists, removing the mute filter for that address. Status updates
    /// from this address will be visible in timeline displays again. If the address
    /// is not found in the mute list, the operation has no effect. The operation is
    /// performed on the main actor to ensure thread safety with SwiftData operations.
    ///
    /// - Parameter address: The user address to remove from the mute list.
    /// - Throws: SwiftData persistence errors if the fetch or save operations fail.
    @MainActor
    func unmuteAddress(
        address: String
    ) throws

    /// Stores a keyword in the local mute list.
    ///
    /// This method creates a new `MutedKeyword` entry in the SwiftData container,
    /// persisting the muted keyword locally. Status updates containing this keyword
    /// (case-insensitive match) will be filtered from timeline displays. The operation
    /// is performed on the main actor to ensure thread safety with SwiftData operations.
    ///
    /// - Parameter keyword: The keyword to add to the mute list.
    /// - Throws: SwiftData persistence errors if the save operation fails.
    @MainActor
    func muteKeyword(
        keyword: String
    ) throws

    /// Removes a keyword from the local mute list.
    ///
    /// This method deletes the `MutedKeyword` entry from the SwiftData container
    /// if it exists, removing the content filter for that keyword. Status updates
    /// containing this keyword will be visible in timeline displays again. If the
    /// keyword is not found in the mute list, the operation has no effect. The operation
    /// is performed on the main actor to ensure thread safety with SwiftData operations.
    ///
    /// - Parameter keyword: The keyword to remove from the mute list.
    /// - Throws: SwiftData persistence errors if the fetch or save operations fail.
    @MainActor
    func unmuteKeyword(
        keyword: String
    ) throws
}

actor StatusPersistenceService: StatusPersistenceServiceProtocol {

    // MARK: - Properties

    let container: ModelContainer
    private let authSessionService: any AuthSessionServiceProtocol
    private var logoutObservationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        container: ModelContainer,
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.container = container
        self.authSessionService = authSessionService

        Task {
            await observeLogoutEvents()
        }
    }

    deinit {
        logoutObservationTask?.cancel()
    }

    // MARK: - Public

    @MainActor
    func storeStatuses(
        statuses: [StorableStatus]
    ) throws {
        try statuses.forEach(storeStatuses)
    }

    // MARK: - Private

    @MainActor
    func muteAddress(
        address: String
    ) throws {
        let mutedAddress = MutedAddress(address: address)
        container.mainContext.insert(mutedAddress)
        try container.mainContext.save()
    }

    @MainActor
    func unmuteAddress(
        address: String
    ) throws {
        let descriptor = FetchDescriptor<MutedAddress>(
            predicate: #Predicate { $0.address == address }
        )

        if let mutedAddress = try container.mainContext.fetch(descriptor).first {
            container.mainContext.delete(mutedAddress)
            try container.mainContext.save()
        }
    }

    @MainActor
    func muteKeyword(
        keyword: String
    ) throws {
        let mutedKeyword = MutedKeyword(keyword: keyword)
        container.mainContext.insert(mutedKeyword)
        try container.mainContext.save()
    }

    @MainActor
    func unmuteKeyword(
        keyword: String
    ) throws {
        let descriptor = FetchDescriptor<MutedKeyword>(
            predicate: #Predicate { $0.keyword == keyword }
        )

        if let mutedKeyword = try container.mainContext.fetch(descriptor).first {
            container.mainContext.delete(mutedKeyword)
            try container.mainContext.save()
        }
    }

    // MARK: - Private

    private func observeLogoutEvents() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: Status.self)
                    try self?.container.mainContext.delete(model: MutedAddress.self)
                    try self?.container.mainContext.delete(model: MutedKeyword.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }

    @MainActor
    private func storeStatuses(
        status: StorableStatus
    ) throws {
        let model = Status.makeStatus(statusPublic: status)
        container.mainContext.insert(model)
        try container.mainContext.save()
    }
}
