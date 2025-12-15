import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to webpage content management.
///
/// This protocol defines the interface for fetching and updating webpage content on a remote server.
/// It provides both synchronous operations and streaming capabilities to observe webpage changes
/// in real-time. Implementations handle network communication and data transformation from
/// API responses to client-friendly models.
///
/// The protocol supports the webpage editing workflow where users can fetch current content,
/// make modifications, and publish updates back to the server.
public protocol WebpageNetworkServiceProtocol: AnyObject, Sendable {

    /// Provides a stream of webpage content changes.
    ///
    /// This method returns an AsyncStream that emits `WebResponse` objects whenever
    /// webpage content is fetched or updated. This enables reactive UI updates and
    /// real-time synchronization between the network and persistence layers.
    ///
    /// The stream continues indefinitely until the service is deallocated.
    ///
    /// - Returns: An `AsyncStream<WebResponse>` that emits webpage updates.
    func webpageStream() -> AsyncStream<WebResponse>

    /// Fetches the current webpage content for a specific address.
    ///
    /// This method retrieves the latest webpage content from the remote server
    /// and emits the result through the webpage stream. The fetched content
    /// includes both the markdown content and the last modification timestamp.
    ///
    /// - Parameter address: The address to fetch webpage content for.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchWebpage(
        for address: String
    ) async throws

    /// Updates the webpage content for a specific address.
    ///
    /// This method uploads new content to the remote server and publishes it immediately.
    /// The update operation replaces the entire webpage content with the provided text.
    ///
    /// Note: This method performs the update but does not emit results through the stream.
    /// Typically, a fetch operation should follow to get the updated content and timestamp.
    ///
    /// - Parameters:
    ///   - address: The address where the webpage should be updated.
    ///   - content: The new markdown content to publish.
    /// - Throws: Network errors, authentication errors, or API errors if the update fails.
    func updateWebpage(
        address: String,
        content: String
    ) async throws
}

actor WebpageNetworkService: WebpageNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol
    private let webpageStreamContinuation: AsyncStream<WebResponse>.Continuation
    private let webpageAsyncStream: AsyncStream<WebResponse>

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient

        let (stream, continuation) = AsyncStream<WebResponse>.makeStream()
        webpageAsyncStream = stream
        webpageStreamContinuation = continuation
    }

    // MARK: - Public

    nonisolated func webpageStream() -> AsyncStream<WebResponse> {
        webpageAsyncStream
    }

    func fetchWebpage(
        for address: String
    ) async throws {
        let response = try await networkClient.run(
            WebpageRequestFactory.makeWebpageRequest(
                address: address
            )
        )

        let webpage = WebResponse(
            webResponse: response.value.response
        )

        webpageStreamContinuation.yield(webpage)
    }

    func updateWebpage(
        address: String,
        content: String
    ) async throws {
        _ = try await networkClient.run(
            WebpageRequestFactory.makeUpdateWebpageRequest(
                address: address,
                content: content,
                publish: true
            )
        )
    }
}

// MARK: - Private

private extension WebResponse {

    /// Initializes the `WebResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter webResponse: The network model to be mapped.
    init(
        webResponse: WebpageResponse.Response
    ) {
        markdownContent = webResponse.content
        timestamp = Double(webResponse.modified) ?? 0
    }
}
