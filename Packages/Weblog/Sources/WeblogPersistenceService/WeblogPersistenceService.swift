import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing weblog entries persistence operations.
///
/// This protocol defines the interface for local storage operations of weblog entries
/// using SwiftData. It handles storing, updating, and deleting weblog entries in the
/// local database, as well as managing data cleanup when users log out.
///
/// All mutation operations are constrained to the main actor to ensure thread safety
/// with SwiftData operations and UI updates.
public protocol WeblogPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for weblog entries persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to weblog entries.
    var container: ModelContainer { get }

    /// Stores multiple weblog entries in the persistent container.
    ///
    /// This method performs a comprehensive sync operation:
    /// 1. Inserts or updates the provided entries in local storage
    /// 2. Removes any locally stored entries that are no longer present in the provided array
    ///
    /// This ensures the local storage accurately reflects the current state of
    /// entries available remotely, removing any entries that may have been deleted
    /// on the server.
    ///
    /// - Parameter entries: An array of `StorableEntry` objects to store locally.
    /// - Throws: SwiftData persistence errors or validation errors.
    @MainActor
    func storeEntries(
        entries: [StorableEntry]
    ) throws

    /// Deletes a specific weblog entry from the persistent container.
    ///
    /// This method removes a single weblog entry identified by its unique ID
    /// and associated address. Use this for targeted deletion operations,
    /// such as when a user explicitly deletes an entry.
    ///
    /// - Parameters:
    ///   - address: The address associated with the entry.
    ///   - entryID: The unique identifier of the entry to delete.
    /// - Throws: SwiftData persistence errors if the deletion operation fails.
    @MainActor
    func deleteEntry(
        address: String,
        entryID: String
    ) throws
}

actor WeblogPersistenceService: WeblogPersistenceServiceProtocol {

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

        Task { await setUpObservers() }
    }

    deinit {
        logoutObservationTask?.cancel()
    }

    // MARK: - Public

    @MainActor
    func storeEntries(
        entries: [StorableEntry]
    ) throws {
        try storeEntries(entries)
        try removeDeletedEntries(entries)
    }

    @MainActor
    func deleteEntry(
        address: String,
        entryID: String
    ) throws {
        let predicate = #Predicate<WeblogEntry> { entry in
            entry.id == entryID && entry.address == address
        }

        try container.mainContext.delete(
            model: WeblogEntry.self,
            where: predicate
        )

        try container.mainContext.save()
    }

    // MARK: - Private

    private func setUpObservers() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: WeblogEntry.self)
                    try self?.container.mainContext.delete(model: WeblogTag.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }

    @MainActor
    private func storeEntries(
        _ entries: [StorableEntry]
    ) throws {
        try removeAllTags()
        try entries.forEach(storeEntry)
    }

    @MainActor
    private func storeEntry(
        entry: StorableEntry
    ) throws {
        let model = WeblogEntry.makeEntry(storableEntry: entry)
        container.mainContext.insert(model)
        try storeTags(entry.tags)
        try container.mainContext.save()
    }

    @MainActor
    private func storeTags(
        _ tags: [String]
    ) throws {
        try tags.forEach(storeTag)
    }

    @MainActor
    private func storeTag(
        _ title: String
    ) throws {
        let newTag = WeblogTag.makeTag(title: title)
        container.mainContext.insert(newTag)
    }

    @MainActor
    private func removeAllTags() throws {
        try container.mainContext.delete(model: WeblogTag.self)
    }

    @MainActor
    private func removeDeletedEntries(
        _ entries: [StorableEntry]
    ) throws {
        let predicate: Predicate<WeblogEntry>

        if entries.isEmpty {
            predicate = #Predicate<WeblogEntry> { _ in true }
        } else {
            let addresses = entries.map(\.address)
            let entryIDs = entries.map(\.id)

            predicate = #Predicate<WeblogEntry> { entry in
                addresses.contains(entry.address) && !entryIDs.contains(entry.id)
            }
        }

        try container.mainContext.delete(
            model: WeblogEntry.self,
            where: predicate
        )

        try container.mainContext.save()
    }
}
