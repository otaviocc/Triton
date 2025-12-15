import Foundation
import MicroClient

/// A factory for creating picture-related API requests.
///
/// `PicsRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL pictures API. The pics feature
/// allows users to upload, manage, and retrieve pictures associated with their
/// OMG.LOL addresses.
///
/// This factory handles all picture operations including browsing all pictures,
/// viewing pictures for a specific user, and uploading new pictures. The pics
/// system provides a simple way to share visual content through OMG.LOL addresses.
///
/// ## Usage Example
/// ```swift
/// // Browse all pictures across the platform
/// let allPicsRequest = PicsRequestFactory.makeAllPicturesRequest()
/// let allPics = try await networkClient.run(allPicsRequest)
///
/// // Get pictures for a specific user
/// let userPicsRequest = PicsRequestFactory.makePicturesRequest(address: "alice")
/// let userPics = try await networkClient.run(userPicsRequest)
///
/// // Upload a new picture
/// let uploadRequest = PicsRequestFactory.makeUploadPictureRequest(
///     address: "alice",
///     data: imageData
/// )
/// try await networkClient.run(uploadRequest)
/// ```
///
/// ## Authentication Requirements
/// Browsing and viewing pictures are typically public operations that do not
/// require authentication. However, uploading pictures requires authentication
/// as the user who owns the address where the picture will be stored.
public enum PicsRequestFactory {

    /// Creates a request to retrieve all pictures across the OMG.LOL platform.
    ///
    /// This method builds a GET request to fetch a comprehensive list of all
    /// pictures uploaded by users across the entire OMG.LOL platform. This is
    /// useful for creating gallery views or discovering content from the community.
    ///
    /// Pictures retrieved through this endpoint are publicly accessible and do
    /// not require authentication. The response includes picture metadata and
    /// URLs for accessing the image content.
    ///
    /// - Returns: A configured network request for retrieving all pictures
    public static func makeAllPicturesRequest() -> NetworkRequest<VoidRequest, PicturesResponse> {
        .init(
            path: "/pics",
            method: .get
        )
    }

    /// Creates a request to retrieve all pictures for a specific user address.
    ///
    /// This method builds a GET request to fetch all pictures uploaded by a
    /// specific user on their OMG.LOL address. This is used for displaying
    /// user-specific picture galleries and browsing content from a particular
    /// user's collection.
    ///
    /// Pictures are typically publicly accessible and do not require
    /// authentication for viewing. The response includes picture metadata,
    /// URLs for accessing the image content, and information about when
    /// pictures were uploaded.
    ///
    /// - Parameter address: The user address (username) whose pictures to retrieve
    /// - Returns: A configured network request for retrieving user-specific pictures
    public static func makePicturesRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, PicturesResponse> {
        .init(
            path: "/address/\(address)/pics",
            method: .get
        )
    }

    /// Creates a request to upload a new picture to a user's address.
    ///
    /// This method builds a PUT request to upload picture data to the specified
    /// user's OMG.LOL address. The picture data should be in a supported image
    /// format (typically JPEG, PNG, GIF) and will be stored and made available
    /// through the user's pics collection.
    ///
    /// This request requires authentication as the user who owns the address
    /// where the picture will be uploaded. The API will process the image data
    /// and make it available through the pics endpoint for that user.
    ///
    /// The uploaded picture will become part of the user's picture collection
    /// and will be accessible through both the all-pictures and user-specific
    /// pictures endpoints.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to upload the picture to
    ///   - data: The binary image data to upload
    /// - Returns: A configured network request for uploading a picture
    public static func makeUploadPictureRequest(
        address: String,
        data: Data
    ) -> NetworkRequest<UploadPictureRequest, UploadOrEditPictureResponse> {
        let body = UploadPictureRequest(
            pic: data.base64EncodedString()
        )

        return .init(
            path: "/address/\(address)/pics/upload",
            method: .post,
            body: body
        )
    }

    /// Creates a request to edit an existing picture's metadata.
    ///
    /// This method builds a PUT request to update the metadata for a previously
    /// uploaded picture on the specified user's OMG.LOL address. The request allows
    /// modification of the picture's caption, alt text, and visibility settings
    /// without affecting the actual image data.
    ///
    /// This request requires authentication as the user who owns the address
    /// where the picture is stored. Only the picture owner can modify picture
    /// metadata. All parameters are optional, allowing for selective updates
    /// of only the desired picture properties.
    ///
    /// The edit operation preserves the original picture data and URL while
    /// updating the specified metadata fields. Any omitted parameters will
    /// leave the corresponding picture properties unchanged.
    ///
    /// ## Usage Example
    /// ```swift
    /// // Update only the caption
    /// let captionRequest = PicsRequestFactory.makeEditPictureRequest(
    ///     address: "alice",
    ///     pictureID: "pic-123",
    ///     caption: "Updated caption for my picture"
    /// )
    /// try await networkClient.run(captionRequest)
    ///
    /// // Update multiple properties
    /// let fullUpdateRequest = PicsRequestFactory.makeEditPictureRequest(
    ///     address: "alice",
    ///     pictureID: "pic-123",
    ///     caption: "My vacation photo",
    ///     alt: "Beach sunset with palm trees",
    ///     isHidden: false
    /// )
    /// try await networkClient.run(fullUpdateRequest)
    /// ```
    ///
    /// - Parameters:
    ///   - address: The user address (username) who owns the picture
    ///   - pictureID: The unique identifier of the picture to edit
    ///   - caption: Optional new caption text for the picture
    ///   - alt: Optional new alt text for accessibility
    ///   - isHidden: Optional visibility setting (true to hide, false to show)
    ///   - tags: Optional array of tags for categorizing and organizing the picture
    /// - Returns: A configured network request for editing picture metadata
    public static func makeEditPictureRequest(
        address: String,
        pictureID: String,
        caption: String? = nil,
        alt: String? = nil,
        isHidden: Bool? = nil,
        tags: [String]? = nil
    ) -> NetworkRequest<EditPictureRequest, UploadOrEditPictureResponse> {
        let body = EditPictureRequest(
            caption: caption,
            alt: alt,
            isHidden: isHidden,
            tags: tags?.joined(separator: ",")
        )

        return .init(
            path: "/address/\(address)/pics/\(pictureID)",
            method: .put,
            body: body
        )
    }

    /// Creates a network request to delete a specific picture.
    ///
    /// This method generates a DELETE request to remove a picture from the specified
    /// OMG.LOL address. Once deleted, the picture will no longer be accessible and
    /// cannot be recovered.
    ///
    /// - Parameters:
    ///   - address: The OMG.LOL address that owns the picture to delete.
    ///   - pictureID: The unique identifier of the picture to delete.
    ///
    /// - Returns: A network request configured to delete the specified picture.
    ///
    /// ## Example
    /// ```swift
    /// let deleteRequest = PicsRequestFactory.makeDeletePictureRequest(
    ///     address: "alice",
    ///     pictureID: "picture123"
    /// )
    /// try await networkClient.run(deleteRequest)
    /// ```
    public static func makeDeletePictureRequest(
        address: String,
        pictureID: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/address/\(address)/pics/\(pictureID)",
            method: .delete
        )
    }
}
