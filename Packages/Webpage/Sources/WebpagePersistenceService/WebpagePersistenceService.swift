import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing webpage content persistence operations.
///
/// This protocol defines the interface for local storage operations of webpage content
/// using SwiftData. It handles storing webpage versions in the local database and
/// managing data cleanup when users log out.
///
/// The service maintains a versioned history of webpage content, storing multiple
/// versions with timestamps to support content history and rollback capabilities.
/// All mutation operations are constrained to the main actor to ensure thread safety
/// with SwiftData operations and UI updates.
public protocol WebpagePersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for webpage content persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to webpage content storage.
    /// The container handles unique constraints and versioning for webpage content.
    var container: ModelContainer { get }

    /// Stores a webpage version in the persistent container.
    ///
    /// This method inserts a new webpage content version into local storage.
    /// Each webpage is identified by its address and timestamp, creating a
    /// versioned history of content changes. The storage follows a limited
    /// retention policy to prevent unlimited growth of stored versions.
    ///
    /// If a webpage with the same address and timestamp already exists,
    /// the SwiftData unique constraints will handle the conflict appropriately.
    ///
    /// - Parameter webpage: A `StorableWebpage` object containing the content and metadata to store.
    /// - Throws: SwiftData persistence errors or validation errors during storage.
    @MainActor
    func storeWebpage(
        webpage: StorableWebpage
    ) throws
}

actor WebpagePersistenceService: WebpagePersistenceServiceProtocol {

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
    func storeWebpage(
        webpage: StorableWebpage
    ) throws {
        let model = Webpage.makeWebpage(storableWebpage: webpage)
        container.mainContext.insert(model)
        try container.mainContext.save()
    }

    // MARK: - Private

    private func observeLogoutEvents() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: Webpage.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }
}
