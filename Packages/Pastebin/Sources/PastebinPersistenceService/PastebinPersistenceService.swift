import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing pastebin persistence operations.
///
/// This protocol defines the interface for local storage operations of text pastes
/// using SwiftData. It handles storing, updating, and deleting paste collections
/// in the local database, as well as managing data cleanup when users log out.
///
/// The service maintains a complete sync of paste collections from the remote server,
/// automatically removing pastes that no longer exist remotely to keep local storage
/// consistent with the server state. All mutation operations are constrained to the
/// main actor to ensure thread safety with SwiftData operations and UI updates.
public protocol PastebinPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for paste persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to paste storage. The container
    /// handles unique constraints to prevent duplicate pastes based on address
    /// and title combinations.
    var container: ModelContainer { get }

    /// Stores multiple pastes in the persistent container with synchronization.
    ///
    /// This method performs a comprehensive sync operation:
    /// 1. Inserts or updates the provided pastes in local storage
    /// 2. Removes any locally stored pastes that are no longer present in the provided array
    ///
    /// This ensures the local storage accurately reflects the current state of
    /// pastes available on the remote server, removing any pastes that may have been
    /// deleted remotely since the last sync.
    ///
    /// - Parameter pastes: An array of `StorablePaste` objects to store locally.
    /// - Throws: SwiftData persistence errors or validation errors during storage operations.
    @MainActor
    func storePastes(
        pastes: [StorablePaste]
    ) throws

    /// Deletes a specific paste from the persistent container.
    ///
    /// This method removes a single paste identified by its address and title combination.
    /// Use this for targeted deletion operations when a paste is deleted individually,
    /// such as through user action or API-driven deletions.
    ///
    /// - Parameters:
    ///   - address: The address associated with the paste.
    ///   - title: The unique title/identifier of the paste to delete.
    /// - Throws: SwiftData persistence errors if the deletion operation fails.
    @MainActor
    func deletePaste(
        address: String,
        title: String
    ) throws
}

actor PastebinPersistenceService: PastebinPersistenceServiceProtocol {

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
    func storePastes(
        pastes: [StorablePaste]
    ) throws {
        try storePastes(pastes)
        try removeDeletedPastes(pastes)
    }

    @MainActor
    func deletePaste(
        address: String,
        title: String
    ) throws {
        let predicate = #Predicate<Paste> { paste in
            paste.title == title && paste.address == address
        }

        try container.mainContext.delete(
            model: Paste.self,
            where: predicate
        )

        try container.mainContext.save()
    }

    // MARK: - Private

    private func setUpObservers() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: Paste.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }

    @MainActor
    private func storePastes(
        _ pastes: [StorablePaste]
    ) throws {
        try pastes.forEach(storePaste)
    }

    @MainActor
    private func storePaste(
        paste: StorablePaste
    ) throws {
        let model = Paste.makePaste(storablePaste: paste)
        container.mainContext.insert(model)
        try container.mainContext.save()
    }

    @MainActor
    private func removeDeletedPastes(
        _ pastes: [StorablePaste]
    ) throws {
        let predicate: Predicate<Paste>

        if pastes.isEmpty {
            predicate = #Predicate<Paste> { _ in true }
        } else {
            let addresses = pastes.map(\.address)
            let titles = pastes.map(\.title)

            predicate = #Predicate<Paste> { paste in
                addresses.contains(paste.address) && !titles.contains(paste.title)
            }
        }

        try container.mainContext.delete(
            model: Paste.self,
            where: predicate
        )

        try container.mainContext.save()
    }
}
