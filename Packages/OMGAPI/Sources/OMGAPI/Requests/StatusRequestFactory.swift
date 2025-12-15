import MicroClient

/// A factory for creating status-related API requests.
///
/// `StatusRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL statuslog API. This factory
/// encapsulates all status-related operations including retrieving status feeds,
/// individual statuses, user bios, and publishing new status updates.
///
/// The statuslog is OMG.LOL's microblogging feature that allows users to share
/// short updates with emojis. This factory provides comprehensive access to
/// both reading and writing statuslog content.
///
/// ## Usage Example
/// ```swift
/// // Get latest statuses across all users
/// let latestRequest = StatusRequestFactory.makeLatestStatusesRequest()
/// let latestStatuses = try await networkClient.run(latestRequest)
///
/// // Post a new status
/// let shareRequest = StatusRequestFactory.makeShareStatusRequest(
///     address: "alice",
///     emoji: "📝",
///     content: "Working on documentation!"
/// )
/// let shareResponse = try await networkClient.run(shareRequest)
/// ```
///
/// ## API Coverage
/// This factory covers the complete statuslog API:
/// - Global status feeds (all users, latest updates)
/// - User-specific status retrieval and bio information
/// - Individual status fetching by ID
/// - Status publishing for authenticated users
public enum StatusRequestFactory {

    /// Creates a request to retrieve all status updates from the global statuslog.
    ///
    /// This method builds a GET request to fetch the complete statuslog containing
    /// status updates from all OMG.LOL users. The response includes status content,
    /// emojis, timestamps, and author information for each status update.
    ///
    /// This endpoint provides access to the public statuslog feed and does not
    /// require authentication.
    ///
    /// - Returns: A configured network request for retrieving all status updates
    public static func makeAllStatusesRequest() -> NetworkRequest<VoidRequest, StatuslogResponse> {
        .init(
            path: "/statuslog",
            method: .get
        )
    }

    /// Creates a request to retrieve the most recent status updates from the global statuslog.
    ///
    /// This method builds a GET request to fetch the latest status updates from
    /// across all OMG.LOL users. This is useful for displaying current activity
    /// and recent updates in feed displays.
    ///
    /// The endpoint returns the same data structure as the all-statuses request
    /// but limited to the most recent updates. No authentication is required.
    ///
    /// - Returns: A configured network request for retrieving latest status updates
    public static func makeLatestStatusesRequest() -> NetworkRequest<VoidRequest, StatuslogResponse> {
        .init(
            path: "/statuslog/latest",
            method: .get
        )
    }

    /// Creates a request to retrieve all status updates for a specific user.
    ///
    /// This method builds a GET request to fetch all status updates posted by
    /// the specified user. This is useful for displaying user-specific status
    /// histories and profile information.
    ///
    /// The request returns status updates in chronological order with complete
    /// status information including content, emojis, and timestamps. No
    /// authentication is required for public status viewing.
    ///
    /// - Parameter address: The user address (username) whose statuses to retrieve
    /// - Returns: A configured network request for retrieving user-specific statuses
    public static func makeAddressStatusesRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, StatuslogResponse> {
        .init(
            path: "/address/\(address)/statuses/",
            method: .get
        )
    }

    /// Creates a request to retrieve the statuslog bio for a specific user.
    ///
    /// This method builds a GET request to fetch the bio information that a user
    /// has set for their statuslog profile. The bio provides additional context
    /// about the user and appears alongside their status updates.
    ///
    /// Bio information is separate from status updates and provides a way for
    /// users to share more permanent information about themselves. No
    /// authentication is required to view public bios.
    ///
    /// - Parameter address: The user address (username) whose bio to retrieve
    /// - Returns: A configured network request for retrieving the user's statuslog bio
    public static func makeAddressBioRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, StatuslogBioResponse> {
        .init(
            path: "/address/\(address)/statuses/bio",
            method: .get
        )
    }

    /// Creates a request to publish a new status update.
    ///
    /// This method builds a POST request to publish a new status update to the
    /// specified user's statuslog. The status includes an emoji and text content
    /// that will appear in the public statuslog feed.
    ///
    /// This request requires authentication as it posts content on behalf of
    /// the authenticated user. The address parameter should match one of the
    /// addresses associated with the authenticated account.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to post the status as
    ///   - emoji: The emoji to display with the status update
    ///   - content: The text content of the status update
    /// - Returns: A configured network request for publishing a new status update
    public static func makeShareStatusRequest(
        address: String,
        emoji: String,
        content: String
    ) -> NetworkRequest<ShareStatusRequest, ShareStatusResponse> {
        let body = ShareStatusRequest(
            emoji: emoji,
            content: content
        )

        return .init(
            path: "/address/\(address)/statuses",
            method: .post,
            body: body
        )
    }

    /// Creates a request to fetch a specific status update by ID.
    ///
    /// This method builds a GET request to retrieve a single status update
    /// by its unique identifier. This is useful for deep-linking to specific
    /// status updates or refreshing individual status information.
    ///
    /// The request returns complete status information including content,
    /// emoji, timestamp, and metadata for the specified status. No
    /// authentication is required for viewing public status updates.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who posted the status
    ///   - statusID: The unique identifier of the status update
    /// - Returns: A configured network request for retrieving a specific status update
    public static func makeIndividualStatusRequest(
        address: String,
        statusID: String
    ) -> NetworkRequest<VoidRequest, StatuslogSingleStatusResponse> {
        .init(
            path: "/address/\(address)/statuses/\(statusID)",
            method: .get
        )
    }
}
