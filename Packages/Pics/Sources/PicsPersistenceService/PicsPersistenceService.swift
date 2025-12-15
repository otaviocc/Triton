import AuthSessionServiceInterface
import Foundation
import SwiftData

/// A protocol for managing pictures persistence operations.
///
/// This protocol defines the interface for local storage operations of pictures
/// using SwiftData. It handles storing, updating, and deleting picture collections
/// in the local database, as well as managing data cleanup when users log out.
///
/// The service maintains a complete sync of picture collections from the remote server,
/// automatically removing pictures that no longer exist remotely to keep local storage
/// consistent with the server state. All mutation operations are constrained to the
/// main actor to ensure thread safety with SwiftData operations and UI updates.
public protocol PicsPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for pictures persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to picture storage. The container
    /// handles unique constraints to prevent duplicate pictures based on their
    /// unique identifiers.
    var container: ModelContainer { get }

    /// Stores multiple pictures in the persistent container with synchronization.
    ///
    /// This method performs a comprehensive sync operation:
    /// 1. Inserts or updates the provided pictures in local storage
    /// 2. Removes any locally stored pictures that are no longer present in the provided array
    ///
    /// This ensures the local storage accurately reflects the current state of
    /// pictures available on the remote server, removing any pictures that may have been
    /// deleted remotely since the last sync.
    ///
    /// - Parameter pictures: An array of `StorablePicture` objects to store locally.
    /// - Throws: SwiftData persistence errors or validation errors during storage operations.
    @MainActor
    func storePictures(
        pictures: [StorablePicture]
    ) throws

    /// Deletes a specific picture from local storage.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL address that owns the picture.
    ///   - pictureID: The unique identifier of the picture to delete.
    ///
    /// - Throws: SwiftData persistence errors if the deletion fails.
    @MainActor
    func deletePicture(
        address: String,
        pictureID: String
    ) throws
}

actor PicsPersistenceService: PicsPersistenceServiceProtocol {

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
    func storePictures(
        pictures: [StorablePicture]
    ) throws {
        try storePictures(pictures)
        try removeDeletedPictures(pictures)
    }

    @MainActor
    func deletePicture(
        address: String,
        pictureID: String
    ) throws {
        let predicate = #Predicate<SomePicture> { picture in
            picture.id == pictureID && picture.address == address
        }

        try container.mainContext.delete(
            model: SomePicture.self,
            where: predicate
        )

        try container.mainContext.save()
    }

    // MARK: - Private

    @MainActor
    private func storePictures(
        _ pictures: [StorablePicture]
    ) throws {
        try removeAllTags()
        try pictures.forEach(storePicture)
    }

    @MainActor
    private func storePicture(
        picture: StorablePicture
    ) throws {
        let model = SomePicture.makePicture(storablePicture: picture)
        container.mainContext.insert(model)
        try storeTags(picture.tags)
        try container.mainContext.save()
    }

    @MainActor
    private func removeAllTags() throws {
        try container.mainContext.delete(model: SomeTag.self)
    }

    @MainActor
    private func removeDeletedPictures(
        _ pictures: [StorablePicture]
    ) throws {
        let predicate: Predicate<SomePicture>

        if pictures.isEmpty {
            predicate = #Predicate<SomePicture> { _ in true }
        } else {
            let addresses = pictures.map(\.address)
            let entryIDs = pictures.map(\.id)

            predicate = #Predicate<SomePicture> { picture in
                addresses.contains(picture.address) && !entryIDs.contains(picture.id)
            }
        }

        try container.mainContext.delete(
            model: SomePicture.self,
            where: predicate
        )

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
        let newTag = SomeTag.makeTag(title: title)
        container.mainContext.insert(newTag)
    }

    private func setUpObservers() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: SomePicture.self)
                    try self?.container.mainContext.delete(model: SomeTag.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }
}
