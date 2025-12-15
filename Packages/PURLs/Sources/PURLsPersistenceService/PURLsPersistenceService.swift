import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing Permanent URL (PURL) persistence operations.
///
/// This protocol defines the interface for local storage operations of PURLs
/// using SwiftData. It handles storing, updating, and deleting PURL collections
/// in the local database, as well as managing data cleanup when users log out.
///
/// The service maintains a complete sync of PURL collections from the remote server,
/// automatically removing PURLs that no longer exist remotely to keep local storage
/// consistent with the server state. All mutation operations are constrained to the
/// main actor to ensure thread safety with SwiftData operations and UI updates.
public protocol PURLsPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for PURL persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to PURL storage. The container
    /// handles unique constraints to prevent duplicate PURLs based on address
    /// and name combinations.
    var container: ModelContainer { get }

    /// Stores multiple PURLs in the persistent container with synchronization.
    ///
    /// This method performs a comprehensive sync operation:
    /// 1. Inserts or updates the provided PURLs in local storage
    /// 2. Removes any locally stored PURLs that are no longer present in the provided array
    ///
    /// This ensures the local storage accurately reflects the current state of
    /// PURLs available on the remote server, removing any PURLs that may have been
    /// deleted remotely since the last sync.
    ///
    /// - Parameter purls: An array of `StorablePURL` objects to store locally.
    /// - Throws: SwiftData persistence errors or validation errors during storage operations.
    @MainActor
    func storePURLs(
        purls: [StorablePURL]
    ) throws

    /// Deletes a specific PURL from the persistent container.
    ///
    /// This method removes a single PURL identified by its address and name combination.
    /// Use this for targeted deletion operations when a PURL is deleted individually,
    /// such as through user action or API-driven deletions.
    ///
    /// - Parameters:
    ///   - address: The address associated with the PURL.
    ///   - name: The unique name/identifier of the PURL to delete.
    /// - Throws: SwiftData persistence errors if the deletion operation fails.
    @MainActor
    func deletePURL(
        address: String,
        name: String
    ) throws
}

actor PURLsPersistenceService: PURLsPersistenceServiceProtocol {

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
    func storePURLs(
        purls: [StorablePURL]
    ) throws {
        try storePURLs(purls)
        try removeDeletedPURLs(purls)
    }

    @MainActor
    func deletePURL(
        address: String,
        name: String
    ) throws {
        let predicate = #Predicate<PURL> { purl in
            purl.name == name && purl.address == address
        }

        try container.mainContext.delete(
            model: PURL.self,
            where: predicate
        )

        try container.mainContext.save()
    }

    // MARK: - Private

    private func observeLogoutEvents() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: PURL.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }

    @MainActor
    private func storePURLs(
        _ purls: [StorablePURL]
    ) throws {
        try purls.forEach(storePURL)
    }

    @MainActor
    private func storePURL(
        purl: StorablePURL
    ) throws {
        let model = PURL.makePURL(storablePURL: purl)
        container.mainContext.insert(model)
        try container.mainContext.save()
    }

    @MainActor
    private func removeDeletedPURLs(
        _ purls: [StorablePURL]
    ) throws {
        let predicate: Predicate<PURL>

        if purls.isEmpty {
            predicate = #Predicate<PURL> { _ in true }
        } else {
            let addresses = purls.map(\.address)
            let names = purls.map(\.name)

            predicate = #Predicate<PURL> { purl in
                addresses.contains(purl.address) && !names.contains(purl.name)
            }
        }

        try container.mainContext.delete(
            model: PURL.self,
            where: predicate
        )

        try container.mainContext.save()
    }
}
