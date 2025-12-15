import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to /now page management.
///
/// This protocol defines the interface for managing /now pages on a remote server.
/// The /now page is a concept from nownownow.com where people share what they're
/// currently focused on in their lives. It provides functionality to fetch and update
/// these personal status pages with optional visibility in public directories.
///
/// The protocol supports both streaming updates for real-time synchronization and
/// individual operations for /now page management. It handles communication with
/// the /now page API and provides data transformation from API responses to
/// client-friendly models.
public protocol NowNetworkServiceProtocol: AnyObject, Sendable {

    /// Provides a stream of /now page content changes.
    ///
    /// This method returns an AsyncStream that emits `NowResponse` objects whenever
    /// /now page content is fetched or updated. This enables reactive UI updates and
    /// real-time synchronization between the network and persistence layers.
    ///
    /// The stream continues indefinitely until the service is deallocated.
    ///
    /// - Returns: An `AsyncStream<NowResponse>` that emits /now page updates.
    func nowStream() -> AsyncStream<NowResponse>

    /// Fetches the current /now page content for a specific address.
    ///
    /// This method retrieves the latest /now page content from the remote server
    /// and emits the result through the /now page stream. The fetched content
    /// includes both the markdown content and metadata such as when it was last
    /// updated and its visibility status.
    ///
    /// - Parameter address: The address to fetch the /now page for.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchNowPage(
        for address: String
    ) async throws

    /// Updates the /now page content for a specific address.
    ///
    /// This method uploads new content to the remote server for the user's /now page.
    /// The update operation replaces the entire /now page content with the provided
    /// markdown text and updates the visibility status in public directories.
    ///
    /// Note: This method performs the update but does not emit results through the stream.
    /// Typically, a fetch operation should follow to get the updated content and timestamp.
    ///
    /// - Parameters:
    ///   - address: The address where the /now page should be updated.
    ///   - content: The new markdown content for the /now page.
    ///   - listed: Whether the /now page should be visible in public directories (true) or private (false).
    /// - Throws: Network errors, authentication errors, or API errors if the update fails.
    func updateNowPage(
        address: String,
        content: String,
        listed: Bool
    ) async throws
}

actor NowNetworkService: NowNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol
    private let nowStreamContinuation: AsyncStream<NowResponse>.Continuation
    private let nowAsyncStream: AsyncStream<NowResponse>

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient

        let (stream, continuation) = AsyncStream<NowResponse>.makeStream()
        nowAsyncStream = stream
        nowStreamContinuation = continuation
    }

    // MARK: - Public

    nonisolated func nowStream() -> AsyncStream<NowResponse> {
        nowAsyncStream
    }

    func fetchNowPage(
        for address: String
    ) async throws {
        let response = try await networkClient.run(
            NowRequestFactory.makeNowRequest(
                address: address
            )
        )

        let now = NowResponse(
            nowResponse: response.value.response.now
        )

        nowStreamContinuation.yield(now)
    }

    func updateNowPage(
        address: String,
        content: String,
        listed: Bool
    ) async throws {
        _ = try await networkClient.run(
            NowRequestFactory.makeUpdateNowRequest(
                address: address,
                content: content,
                listed: listed
            )
        )
    }
}

// MARK: - Private

private extension NowResponse {

    /// Initializes the `NowResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter nowResponse: The network model to be mapped.
    init(
        nowResponse: NowPageResponse.Response.NowResponse
    ) {
        markdownContent = nowResponse.content
        updated = nowResponse.updated
        listed = nowResponse.listed
    }
}
