import MicroClient

/// A factory for creating webpage-related API requests.
///
/// `WebpageRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL web page feature. This feature
/// allows users to create and maintain a simple web page at their OMG.LOL address,
/// providing a personal homepage or landing page.
///
/// The web page feature enables users to publish HTML content that becomes
/// accessible at their main OMG.LOL address URL, serving as their primary
/// web presence on the platform.
///
/// ## Usage Example
/// ```swift
/// // Get someone's current web page
/// let webRequest = WebpageRequestFactory.makeWebpageRequest(address: "alice")
/// let webpage = try await networkClient.run(webRequest)
///
/// // Update your web page
/// let updateRequest = WebpageRequestFactory.makeUpdateWebpageRequest(
///     address: "alice",
///     content: "<h1>Welcome to Alice's Page</h1><p>This is my homepage!</p>",
///     publish: true
/// )
/// let updateResponse = try await networkClient.run(updateRequest)
/// ```
///
/// ## Content Publishing
/// Web pages support HTML content and can be published or kept as drafts
/// through the `publish` parameter in update requests.
public enum WebpageRequestFactory {

    /// Creates a request to retrieve a user's web page content.
    ///
    /// This method builds a GET request to fetch the current web page content
    /// for the specified user. The web page serves as the user's main homepage
    /// at their OMG.LOL address and can contain HTML content, links, and
    /// personal information.
    ///
    /// Web pages are typically publicly accessible and provide users with
    /// a way to create a simple homepage or landing page for their OMG.LOL
    /// address.
    ///
    /// - Parameter address: The user address (username) whose web page to retrieve
    /// - Returns: A configured network request for retrieving the web page content
    public static func makeWebpageRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, WebpageResponse> {
        .init(
            path: "/address/\(address)/web",
            method: .get
        )
    }

    /// Creates a request to update a user's web page content.
    ///
    /// This method builds a POST request to update the web page with new
    /// HTML content and publication status. The web page serves as the
    /// user's main homepage and can include any valid HTML content.
    ///
    /// The `publish` parameter controls whether the updated content is
    /// immediately published and made publicly accessible, or kept as a
    /// draft for further editing before publication.
    ///
    /// This request requires authentication as it updates content on behalf
    /// of the authenticated user. The content can include HTML, CSS, and
    /// JavaScript as supported by the OMG.LOL platform.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to update the web page for
    ///   - content: The HTML content for the web page
    ///   - publish: Whether to publish the content immediately or save as draft
    /// - Returns: A configured network request for updating the web page
    public static func makeUpdateWebpageRequest(
        address: String,
        content: String,
        publish: Bool
    ) -> NetworkRequest<UpdateWebpageRequest, UpdateWebpageResponse> {
        let body = UpdateWebpageRequest(
            content: content,
            publish: publish
        )

        return .init(
            path: "/address/\(address)/web",
            method: .post,
            body: body
        )
    }
}
