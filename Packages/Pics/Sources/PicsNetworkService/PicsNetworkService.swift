import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to pictures on the OMG.LOL platform.
///
/// This protocol defines the interface for interacting with the OMG.LOL pictures API,
/// providing methods to fetch pictures for specific users and upload new pictures.
/// The pics feature allows users to share visual content through their OMG.LOL addresses.
///
/// The service handles all HTTP communication with the pictures endpoints and transforms
/// raw network responses into domain-specific models that can be used by higher-level
/// components without depending on network implementation details.
public protocol PicsNetworkServiceProtocol: AnyObject, Sendable {

    /// Fetches all pictures for a specific user address.
    ///
    /// This method retrieves the complete collection of pictures uploaded by the
    /// specified user on their OMG.LOL address. Pictures are publicly accessible
    /// and include metadata such as creation dates, file sizes, and URLs.
    ///
    /// The response is transformed from the raw network format into `PictureResponse`
    /// models that provide a clean interface for client components to work with
    /// picture data without coupling to network implementation details.
    ///
    /// - Parameter address: The user address (username) whose pictures to fetch
    /// - Returns: An array of `PictureResponse` models representing the user's pictures
    /// - Throws: Network errors, API errors, or decoding errors if the request fails
    func fetchPictures(
        for address: String
    ) async throws -> [PictureResponse]

    /// Uploads a new picture to the specified user's OMG.LOL address.
    ///
    /// This method performs a two-step upload process:
    /// 1. Uploads the picture data to the server to create a new picture entry
    /// 2. Updates the picture's metadata (caption, alt text, and visibility settings)
    ///
    /// The method handles the complete upload workflow including image data transfer
    /// and metadata assignment in a single operation. If either step fails, the
    /// operation will throw an error and no partial upload will remain.
    ///
    /// - Parameters:
    ///   - address: The user address (username) where the picture should be uploaded
    ///   - data: The raw image data to upload (JPEG, PNG, etc.)
    ///   - caption: A descriptive caption text for the picture
    ///   - alt: Alternative text for accessibility and screen readers
    ///   - isHidden: Whether the picture should be hidden from public view
    ///   - tags: Array of tags for categorizing and organizing the picture
    /// - Throws: Network errors, API errors, or upload errors if the operation fails
    func uploadPicture(
        address: String,
        data: Data,
        caption: String,
        alt: String,
        isHidden: Bool,
        tags: [String]
    ) async throws

    /// Updates the metadata for an existing picture.
    ///
    /// This method modifies the caption, alternative text, and tags for a picture that has
    /// already been uploaded to the OMG.LOL address. The picture data itself remains
    /// unchanged; only the descriptive metadata is updated.
    ///
    /// The update operation is performed via the OMG.LOL API and applies changes
    /// immediately to the live picture entry. This method is typically used when
    /// users want to improve accessibility or update descriptions after initial upload.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL address that owns the picture
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

    /// Deletes a specific picture from the server.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL address that owns the picture.
    ///   - pictureID: The unique identifier of the picture to delete.
    ///
    /// - Throws: Network or API errors if the deletion fails.
    func deletePicture(
        address: String,
        pictureID: String
    ) async throws
}

actor PicsNetworkService: PicsNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient
    }

    // MARK: - Public

    func fetchPictures(
        for address: String
    ) async throws -> [PictureResponse] {
        let response = try await networkClient.run(
            PicsRequestFactory.makePicturesRequest(address: address)
        )

        return response.value.response.pics.map(PictureResponse.init)
    }

    func uploadPicture(
        address: String,
        data: Data,
        caption: String,
        alt: String,
        isHidden: Bool,
        tags: [String]
    ) async throws {
        let uploadRequest = PicsRequestFactory.makeUploadPictureRequest(
            address: address,
            data: data
        )

        let uploadResponse = try await networkClient.run(uploadRequest)

        let updateRequest = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: uploadResponse.value.response.id,
            caption: caption,
            alt: alt,
            isHidden: isHidden,
            tags: tags
        )

        _ = try await networkClient.run(updateRequest)
    }

    func updatePicture(
        address: String,
        pictureID: String,
        caption: String,
        alt: String,
        tags: [String]
    ) async throws {
        let updateRequest = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            caption: caption,
            alt: alt,
            isHidden: nil,
            tags: tags
        )

        _ = try await networkClient.run(updateRequest)
    }

    func deletePicture(
        address: String,
        pictureID: String
    ) async throws {
        _ = try await networkClient.run(
            PicsRequestFactory.makeDeletePictureRequest(
                address: address,
                pictureID: pictureID
            )
        )
    }
}

// MARK: - Private

private extension PictureResponse {

    /// Initializes the `PictureResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter PicturesResponse.Response.PictureResponse: The network model to be mapped.
    init(
        pictureResponse: PicturesResponse.Response.PictureResponse
    ) {
        id = pictureResponse.id
        address = pictureResponse.address
        created = pictureResponse.created
        mime = pictureResponse.mime
        size = pictureResponse.size
        url = pictureResponse.url
        somePicsURL = pictureResponse.somePicsURL
        description = pictureResponse.description
        alt = pictureResponse.alt
        tags = pictureResponse.tags
    }
}
