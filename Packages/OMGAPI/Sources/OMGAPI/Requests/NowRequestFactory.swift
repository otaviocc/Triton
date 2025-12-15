import MicroClient

/// A factory for creating "Now" page related API requests.
///
/// `NowRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL "Now" page feature. Now pages
/// are inspired by Derek Sivers' idea of sharing what you're focused on right now,
/// providing a simple way to communicate current priorities and activities.
///
/// The Now page feature allows users to maintain a current status that's more
/// permanent than a status update but more dynamic than a bio. It's perfect
/// for sharing what you're currently working on, reading, or focused on.
///
/// ## Usage Example
/// ```swift
/// // Get someone's current "Now" page
/// let nowRequest = NowRequestFactory.makeNowRequest(address: "alice")
/// let nowPage = try await networkClient.run(nowRequest)
///
/// // Update your own "Now" page
/// let updateRequest = NowRequestFactory.makeUpdateNowRequest(
///     address: "alice",
///     content: "Working on a new iOS app using SwiftUI",
///     listed: true
/// )
/// let updateResponse = try await networkClient.run(updateRequest)
/// ```
///
/// ## Privacy Control
/// Now pages can be configured to be listed publicly or kept private through
/// the `listed` parameter in update requests.
public enum NowRequestFactory {

    /// Creates a request to retrieve a user's "Now" page.
    ///
    /// This method builds a GET request to fetch the current "Now" page content
    /// for the specified user. The Now page represents what the user is currently
    /// focused on or working on, providing insight into their current priorities.
    ///
    /// Now pages are typically publicly accessible and provide a way for users
    /// to share their current status in a more permanent format than status
    /// updates but more dynamic than a static bio.
    ///
    /// - Parameter address: The user address (username) whose "Now" page to retrieve
    /// - Returns: A configured network request for retrieving the "Now" page content
    public static func makeNowRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, NowPageResponse> {
        .init(
            path: "/address/\(address)/now",
            method: .get
        )
    }

    /// Creates a request to update a user's "Now" page content.
    ///
    /// This method builds a POST request to update the "Now" page with new
    /// content and visibility settings. The request allows users to share
    /// what they're currently working on or focused on.
    ///
    /// The `listed` parameter controls whether the Now page appears in public
    /// listings and directories. When set to `false`, the page is still accessible
    /// via direct link but won't appear in public Now page collections.
    ///
    /// This request requires authentication as it updates content on behalf
    /// of the authenticated user.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to update the "Now" page for
    ///   - content: The text content describing what the user is currently focused on
    ///   - listed: Whether the "Now" page should be publicly listed in directories
    /// - Returns: A configured network request for updating the "Now" page
    public static func makeUpdateNowRequest(
        address: String,
        content: String,
        listed: Bool
    ) -> NetworkRequest<UpdateNowPageRequest, UpdateNowPageResponse> {
        let body = UpdateNowPageRequest(
            content: content,
            listed: listed ? 1 : 0
        )

        return .init(
            path: "/address/\(address)/now",
            method: .post,
            body: body
        )
    }
}
