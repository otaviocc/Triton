import MicroClient

/// A factory for creating pastebin-related API requests.
///
/// `PastebinRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL pastebin feature. The pastebin
/// allows users to share text content, code snippets, and other textual data
/// through simple, shareable URLs.
///
/// The pastebin feature provides a way to share temporary or permanent text
/// content without requiring a full blog post or status update. It's perfect
/// for sharing code, configuration files, logs, or other text-based content.
///
/// ## Usage Example
/// ```swift
/// // Get all pastes for a user
/// let pastesRequest = PastebinRequestFactory.makePastesRequest(address: "alice")
/// let pastes = try await networkClient.run(pastesRequest)
///
/// // Create a new paste
/// let createRequest = PastebinRequestFactory.makeCreateOrUpdatePasteRequest(
///     address: "alice",
///     title: "config-example",
///     content: "server = localhost\nport = 8080",
///     isListed: true
/// )
/// let newPaste = try await networkClient.run(createRequest)
///
/// // Delete a paste
/// let deleteRequest = PastebinRequestFactory.makeDeletePasteRequest(
///     address: "alice",
///     title: "config-example"
/// )
/// try await networkClient.run(deleteRequest)
/// ```
///
/// ## Content Management
/// Pastes can be listed publicly or kept private, and support both creation
/// and updating through the same endpoint using the title as an identifier.
public enum PastebinRequestFactory {

    /// Creates a request to retrieve all pastes for a specific user.
    ///
    /// This method builds a GET request to fetch the complete list of pastes
    /// that have been created by the specified user. The response includes
    /// paste metadata such as titles, creation dates, and content previews.
    ///
    /// The pastebin provides a way for users to share text content, code
    /// snippets, and other textual information through easily shareable URLs.
    /// This endpoint returns all configured pastes for management purposes.
    ///
    /// - Parameter address: The user address (username) whose pastes to retrieve
    /// - Returns: A configured network request for retrieving all user pastes
    public static func makePastesRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, PastesResponse> {
        .init(
            path: "/address/\(address)/pastebin",
            method: .get
        )
    }

    /// Creates a request to create a new paste or update an existing one.
    ///
    /// This method builds a POST request to create a new paste or update an
    /// existing paste with the same title. The paste will be accessible at
    /// a URL based on the user's address and the chosen title.
    ///
    /// The `isListed` parameter controls whether the paste appears in public
    /// paste listings. When set to `false`, the paste is still accessible
    /// via direct link but won't appear in public directories.
    ///
    /// If a paste with the same title already exists, this request will update
    /// its content and listing status. This provides a simple way to maintain
    /// and revise shared text content.
    ///
    /// This request requires authentication as it creates or modifies content
    /// on behalf of the authenticated user.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to create/update the paste for
    ///   - title: The title/identifier for the paste (becomes part of the URL)
    ///   - content: The text content of the paste
    ///   - isListed: Whether the paste should be publicly listed in directories
    /// - Returns: A configured network request for creating or updating a paste
    public static func makeCreateOrUpdatePasteRequest(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) -> NetworkRequest<CreateOrUpdatePasteRequest, CreateOrUpdatePasteResponse> {
        let payload = CreateOrUpdatePasteRequest(
            title: title,
            content: content,
            listed: isListed
        )

        return .init(
            path: "/address/\(address)/pastebin",
            method: .post,
            body: payload
        )
    }

    /// Creates a request to delete a specific paste.
    ///
    /// This method builds a DELETE request to remove a paste from the user's
    /// pastebin. Once deleted, the paste URL will no longer be accessible
    /// and will return a 404 error.
    ///
    /// This request requires authentication as it modifies the user's content.
    /// The operation is irreversible, though the same title can be reused
    /// for a new paste after deletion.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who owns the paste
    ///   - title: The title/identifier of the paste to delete
    /// - Returns: A configured network request for deleting the specified paste
    public static func makeDeletePasteRequest(
        address: String,
        title: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/address/\(address)/pastebin/\(title)",
            method: .delete
        )
    }
}
