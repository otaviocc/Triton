import MicroClient

/// A factory for creating PURL (Persistent URL) related API requests.
///
/// `PURLsRequestFactory` provides static methods for creating pre-configured
/// network requests to manage PURLs through the OMG.LOL API. PURLs are
/// persistent URLs that allow users to create short, memorable links that
/// redirect to longer URLs.
///
/// PURLs are useful for creating branded short links, managing redirects,
/// and providing stable URLs for content that might move. This factory
/// provides complete CRUD operations for PURL management.
///
/// ## Usage Example
/// ```swift
/// // Get all PURLs for a user
/// let listRequest = PURLsRequestFactory.makeAllPURLsRequest(address: "alice")
/// let purls = try await networkClient.run(listRequest)
///
/// // Create a new PURL
/// let createRequest = PURLsRequestFactory.makeCreatePURLRequest(
///     address: "alice",
///     name: "blog",
///     url: "https://alice.example.com/blog"
/// )
/// let newPURL = try await networkClient.run(createRequest)
///
/// // Delete a PURL
/// let deleteRequest = PURLsRequestFactory.makeDeletePURLRequest(
///     address: "alice",
///     name: "blog"
/// )
/// try await networkClient.run(deleteRequest)
/// ```
///
/// ## Authentication
/// Creating and deleting PURLs require authentication, while listing PURLs
/// may be publicly accessible depending on the user's configuration.
public enum PURLsRequestFactory {

    /// Creates a request to retrieve all PURLs for a specific user.
    ///
    /// This method builds a GET request to fetch the complete list of PURLs
    /// (Persistent URLs) that have been created for the specified user address.
    /// The response includes PURL names, target URLs, and metadata.
    ///
    /// PURLs provide a way to create short, branded links that redirect to
    /// longer URLs. This endpoint returns all configured PURLs for management
    /// and display purposes.
    ///
    /// - Parameter address: The user address (username) whose PURLs to retrieve
    /// - Returns: A configured network request for retrieving all PURLs
    public static func makeAllPURLsRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, PURLsResponse> {
        .init(
            path: "/address/\(address)/purls",
            method: .get
        )
    }

    /// Creates a request to create a new PURL for a specific user.
    ///
    /// This method builds a POST request to create a new PURL (Persistent URL)
    /// that will redirect to the specified target URL. The PURL will be accessible
    /// at a short URL based on the user's address and the chosen name.
    ///
    /// The created PURL will be available at a URL like:
    /// `https://username.omg.lol/name` redirecting to the target URL.
    ///
    /// This request requires authentication as it modifies the user's PURL
    /// configuration on their behalf.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to create the PURL for
    ///   - name: The short name for the PURL (becomes part of the short URL)
    ///   - url: The target URL that the PURL will redirect to
    /// - Returns: A configured network request for creating a new PURL
    public static func makeCreatePURLRequest(
        address: String,
        name: String,
        url: String
    ) -> NetworkRequest<CreatePURLRequest, CreatePURLResponse> {
        let body = CreatePURLRequest(
            address: address,
            name: name,
            url: url
        )

        return .init(
            path: "/address/\(address)/purl",
            method: .post,
            body: body
        )
    }

    /// Creates a request to delete a specific PURL.
    ///
    /// This method builds a DELETE request to remove a PURL from the user's
    /// configuration. Once deleted, the short URL will no longer redirect
    /// and will return a 404 error.
    ///
    /// This request requires authentication as it modifies the user's PURL
    /// configuration. The operation is irreversible, so the PURL name can
    /// be reused for a different target URL after deletion.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who owns the PURL
    ///   - name: The name of the PURL to delete
    /// - Returns: A configured network request for deleting the specified PURL
    public static func makeDeletePURLRequest(
        address: String,
        name: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/address/\(address)/purl/\(name)",
            method: .delete
        )
    }
}
