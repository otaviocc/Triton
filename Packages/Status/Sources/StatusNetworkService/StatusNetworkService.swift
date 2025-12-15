import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to status updates and social timeline management.
///
/// This protocol defines the interface for fetching status updates from other users,
/// posting new status updates, and maintaining a real-time stream of status changes.
/// It handles communication with the statuslog API and provides both streaming and
/// on-demand access to status data.
///
/// The protocol supports the social timeline feature where users can view status updates
/// from others in their network and publish their own status updates with emoji icons
/// and markdown content.
public protocol StatusNetworkServiceProtocol: AnyObject, Sendable {

    /// Posts a new status update to the network.
    ///
    /// This method publishes a new status update with an emoji icon and markdown content
    /// to the statuslog service. The status will appear in other users' timelines and
    /// becomes part of the public status feed.
    ///
    /// Status updates support markdown formatting for rich text content and require
    /// an emoji icon to provide visual context for the status.
    ///
    /// - Parameters:
    ///   - address: The user address posting the status update.
    ///   - emoji: The emoji icon to associate with the status for visual representation.
    ///   - content: The markdown-formatted content of the status update.
    /// - Throws: Network errors, authentication errors, or API validation errors if the post fails.
    func postStatus(
        address: String,
        emoji: String,
        content: String
    ) async throws

    /// Fetches the current latest status updates on-demand.
    ///
    /// This method performs an immediate fetch of the latest status updates from
    /// the network without waiting for the automatic streaming interval. Use this
    /// method when you need to refresh the status timeline immediately, such as
    /// after posting a new status or when manually refreshing the UI.
    ///
    /// Unlike the streaming method, this returns the results directly and does not
    /// emit them through any continuous stream.
    ///
    /// - Returns: An array of `StatusResponse` objects representing the latest status updates.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchStatuses() async throws -> [StatusResponse]
}

actor StatusNetworkService: StatusNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient
    }

    func postStatus(
        address: String,
        emoji: String,
        content: String
    ) async throws {
        let request = StatusRequestFactory
            .makeShareStatusRequest(
                address: address,
                emoji: emoji,
                content: content
            )

        _ = try await networkClient.run(request)
    }

    func fetchStatuses() async throws -> [StatusResponse] {
        let response = try await networkClient.run(
            StatusRequestFactory.makeLatestStatusesRequest()
        )

        return response.value.response.statuses.map(StatusResponse.init)
    }
}

// MARK: - Private

private extension StatusResponse {

    /// Initializes the `StatusResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter statusResponse: The network model to be mapped.
    init(
        statusResponse: StatuslogStatusResponse
    ) {
        id = statusResponse.id
        address = statusResponse.address
        timestamp = statusResponse.created
        emojiIcon = statusResponse.emoji
        markdownContent = statusResponse.content
        externalURL = statusResponse.externalURL
    }
}
