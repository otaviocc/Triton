import AuthSessionServiceInterface
import Foundation
import SessionServiceInterface
import SwiftData
import WeblogNetworkService
import WeblogPersistenceService

/// A repository protocol for managing weblog entries data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide weblog entries data. It handles fetching entries from remote sources and
/// managing local storage through SwiftData.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with weblog data.
public protocol WeblogRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying weblog entries.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// weblog entries data changes.
    var entriesContainer: ModelContainer { get }

    /// Fetches weblog entries for the currently authenticated user's address.
    ///
    /// This method coordinates between the network and persistence layers to:
    /// 1. Verify the user is authenticated
    /// 2. Get the current user's address from session
    /// 3. Fetch entries from the remote server
    /// 4. Store the fetched entries in local persistence
    /// 5. Remove any entries that are no longer available remotely
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation or persistence errors
    ///           from the local storage operations.
    func fetchEntries() async throws

    /// Creates a new weblog entry or updates an existing one for the specified address.
    ///
    /// This method determines whether to create a new entry or update an existing one
    /// based on the presence of an entry ID. It coordinates between the network and
    /// persistence layers to ensure data consistency.
    ///
    /// For creation (when entryID is nil):
    /// 1. Validates the user is authenticated
    /// 2. Creates the entry via network service for the specified address
    /// 3. Stores the new entry in local persistence
    ///
    /// For updates (when entryID is provided):
    /// 1. Validates the user is authenticated
    /// 2. Updates the entry via network service for the specified address
    /// 3. Updates the entry in local persistence
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The address for which to create or update the weblog entry.
    ///   - entryID: The unique identifier of the entry to update. If nil, creates a new entry.
    ///   - body: The content body of the weblog entry in markdown format
    ///   - date: The publication date for the entry
    /// - Throws: Network errors from the remote operation or persistence errors
    ///           from the local storage operations.
    func createOrUpdateEntry(
        address: String,
        entryID: String?,
        body: String,
        date: Date
    ) async throws

    /// Deletes a weblog entry from both local storage and the server for the specified address.
    ///
    /// This method performs a two-phase deletion: first removing the entry from
    /// the server via the network service for the specified address, then removing
    /// it from local persistence.
    ///
    /// - Parameters:
    ///   - address: The address that owns the weblog entry.
    ///   - entryID: The unique identifier of the weblog entry to delete
    /// - Throws: Network errors if server deletion fails, or persistence errors
    ///   if local deletion fails
    func deleteEntry(
        address: String,
        entryID: String
    ) async throws
}

actor WeblogRepository: WeblogRepositoryProtocol {

    // MARK: - Properties

    nonisolated var entriesContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any WeblogNetworkServiceProtocol
    private let persistenceService: any WeblogPersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol

    // MARK: - Lifecycle

    init(
        networkService: any WeblogNetworkServiceProtocol,
        persistenceService: any WeblogPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService
    }

    // MARK: - Public

    func fetchEntries() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        let entries = try await networkService.fetchWeblogEntries(
            for: current
        )

        let storableEntries = entries.map(StorableEntry.init)

        try await persistenceService.storeEntries(
            entries: storableEntries
        )
    }

    func createOrUpdateEntry(
        address: String,
        entryID: String? = nil,
        body: String,
        date: Date
    ) async throws {
        if let entryID {
            try await updateEntry(
                address: address,
                entryID: entryID,
                body: body,
                date: date
            )
        } else {
            try await createEntry(
                address: address,
                body: body,
                date: date
            )
        }
    }

    // MARK: - Private

    private func createEntry(
        address: String,
        body: String,
        date: Date
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        _ = try await networkService.createWeblogEntry(
            address: address,
            content: body,
            date: date
        )

        try await fetchEntries()
    }

    private func updateEntry(
        address: String,
        entryID: String,
        body: String,
        date: Date
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        _ = try await networkService.updateWeblogEntry(
            address: address,
            entryID: entryID,
            content: body,
            date: date
        )

        try await fetchEntries()
    }

    func deleteEntry(
        address: String,
        entryID: String
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.deleteWeblogEntry(
            address: address,
            entryID: entryID
        )

        try await fetchEntries()
    }
}
