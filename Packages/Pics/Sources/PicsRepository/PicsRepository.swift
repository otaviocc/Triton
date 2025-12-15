import AuthSessionServiceInterface
import Foundation
import PicsNetworkService
import PicsPersistenceService
import SessionServiceInterface
import SwiftData

/// A repository protocol for managing pictures data operations.
///
/// This protocol defines the interface for coordinating between network and persistence layers
/// to provide picture management functionality. It handles fetching pictures from remote sources,
/// managing local storage through SwiftData, and coordinating synchronization operations for images.
///
/// The repository follows the repository pattern, abstracting data access and providing
/// a clean interface for higher-level components to interact with picture data. It coordinates
/// local and remote operations for consistent image data management and provides offline access
/// to picture collections through the persistence layer.
public protocol PicsRepositoryProtocol: Sendable {

    /// The SwiftData model container used for querying pictures.
    ///
    /// This container provides access to the persistence layer and can be used
    /// by SwiftUI views and other components that need to query or observe
    /// picture collection changes. The container maintains the local cache of
    /// pictures for the authenticated user.
    var picturesContainer: ModelContainer { get }

    /// Fetches pictures for the currently authenticated user's address.
    ///
    /// This method coordinates the fetching of pictures by:
    /// 1. Verifying the user is authenticated
    /// 2. Getting the current user's address from session
    /// 3. Requesting all pictures from the remote server for that address
    /// 4. Converting the network response to storable format
    /// 5. Storing the pictures locally via the persistence service
    ///
    /// The method will silently return if the user is not authenticated or
    /// no address is available in the session.
    ///
    /// - Throws: Network errors from the remote fetch operation or persistence errors.
    func fetchPictures() async throws

    /// Uploads a new picture for the currently authenticated user.
    ///
    /// This method coordinates the picture upload process by:
    /// 1. Verifying the user is authenticated and has a valid session
    /// 2. Delegating to the network service to perform the actual upload and metadata update
    /// 3. Ensuring the operation only proceeds for authenticated users with valid addresses
    ///
    /// The method will silently return without performing any operation if the user
    /// is not authenticated or no address is available in the current session.
    /// This ensures upload operations are only available to properly authenticated users.
    ///
    /// - Parameters:
    ///   - address: The user address where the picture should be uploaded
    ///   - data: The raw image data to upload (JPEG, PNG, etc.)
    ///   - caption: A descriptive caption text for the picture
    ///   - alt: Alternative text for accessibility and screen readers
    ///   - isHidden: Whether the picture should be hidden from public view
    ///   - tags: Array of tags for categorizing and organizing the picture
    /// - Throws: Network errors, API errors, or authentication errors if the upload fails
    func uploadPicture(
        address: String,
        data: Data,
        caption: String,
        alt: String,
        isHidden: Bool,
        tags: [String]
    ) async throws

    /// Updates the metadata for an existing picture for the specified address.
    ///
    /// This method coordinates the update of a picture's caption, alternative text, and tags.
    /// It verifies authentication before delegating to the network service to perform
    /// the actual metadata update for the specified address.
    ///
    /// The method will silently return without performing any operation if the user
    /// is not authenticated. This ensures update operations are only available to
    /// properly authenticated users.
    ///
    /// - Parameters:
    ///   - address: The address that owns the picture.
    ///   - pictureID: The unique identifier of the picture to update
    ///   - caption: The new caption text for the picture
    ///   - alt: The new alternative text for accessibility
    ///   - tags: Array of tags for categorizing and organizing the picture
    /// - Throws: Network errors or API errors if the update fails
    func updatePicture(
        address: String,
        pictureID: String,
        caption: String,
        alt: String,
        tags: [String]
    ) async throws

    /// Deletes a picture both from the server and local storage for the specified address.
    ///
    /// This method coordinates the deletion of a picture by removing it from both
    /// the remote server and the local persistence layer to maintain data consistency.
    ///
    /// The method will silently return if the user is not authenticated.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL address that owns the picture.
    ///   - pictureID: The unique identifier of the picture to delete.
    ///
    /// - Throws: Network errors, API errors, persistence errors, or authentication errors if the deletion fails.
    func deletePicture(
        address: String,
        pictureID: String
    ) async throws
}

actor PicsRepository: PicsRepositoryProtocol {

    // MARK: - Properties

    nonisolated var picturesContainer: ModelContainer {
        persistenceService.container
    }

    private let networkService: any PicsNetworkServiceProtocol
    private let persistenceService: any PicsPersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol

    // MARK: - Lifecycle

    init(
        networkService: any PicsNetworkServiceProtocol,
        persistenceService: any PicsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService
        self.sessionService = sessionService
    }

    // MARK: - Public

    func fetchPictures() async throws {
        guard
            await authSessionService.isLoggedIn,
            case let .address(current) = await sessionService.address
        else {
            return
        }

        let pictures = try await networkService.fetchPictures(
            for: current
        )

        let storableEntries = pictures.map(StorablePicture.init)

        try await persistenceService.storePictures(
            pictures: storableEntries
        )
    }

    func uploadPicture(
        address: String,
        data: Data,
        caption: String,
        alt: String,
        isHidden: Bool,
        tags: [String]
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.uploadPicture(
            address: address,
            data: data,
            caption: caption,
            alt: alt,
            isHidden: isHidden,
            tags: tags
        )
    }

    func updatePicture(
        address: String,
        pictureID: String,
        caption: String,
        alt: String,
        tags: [String]
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.updatePicture(
            address: address,
            pictureID: pictureID,
            caption: caption,
            alt: alt,
            tags: tags
        )
    }

    func deletePicture(
        address: String,
        pictureID: String
    ) async throws {
        guard await authSessionService.isLoggedIn else {
            return
        }

        try await networkService.deletePicture(
            address: address,
            pictureID: pictureID
        )

        do {
            try await persistenceService.deletePicture(
                address: address,
                pictureID: pictureID
            )
        } catch {
            print("Failed to delete Picture from persistence: \(error)")
        }
    }
}
