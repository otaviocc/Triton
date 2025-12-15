import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to Permanent URL (PURL) management.
///
/// This protocol defines the interface for managing PURLs on a remote server, providing
/// functionality to create, fetch, and delete permanent URLs. PURLs are short, memorable
/// URLs that redirect to longer target URLs, providing a stable way to share and manage
/// web links that may change over time.
///
/// The protocol supports both streaming updates for real-time synchronization and individual
/// operations for PURL management. It handles communication with the PURL API and provides
/// data transformation from API responses to client-friendly models.
public protocol PURLsNetworkServiceProtocol: AnyObject, Sendable {

    /// Provides a stream of PURL collection updates.
    ///
    /// This method returns an AsyncStream that emits arrays of `PURLResponse` objects
    /// whenever PURL collections are fetched or modified. This enables reactive UI updates
    /// and real-time synchronization between network operations and local storage.
    ///
    /// The stream emits updates when PURLs are fetched or when new PURLs are created,
    /// ensuring that observers receive the most current PURL collection state.
    ///
    /// - Returns: An `AsyncStream<[PURLResponse]>` that emits PURL collection updates.
    func purlsStream() -> AsyncStream<[PURLResponse]>

    /// Fetches all PURLs for a specific address and emits them through the stream.
    ///
    /// This method retrieves all PURLs associated with the given address from the
    /// remote server and emits the results through the PURLs stream. The fetched
    /// PURLs represent all permanent URLs currently configured for the address.
    ///
    /// - Parameter address: The address to fetch PURLs for.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchPURLs(
        for address: String
    ) async throws

    /// Creates a new PURL and refreshes the collection.
    ///
    /// This method creates a new permanent URL on the remote server with the specified
    /// name and target URL. After successful creation, it automatically fetches and
    /// emits the updated PURL collection through the stream to ensure all observers
    /// receive the latest state including the newly created PURL.
    ///
    /// The PURL name must be unique within the address and will be used as the
    /// permanent identifier for the redirect.
    ///
    /// - Parameters:
    ///   - address: The address where the PURL should be created.
    ///   - name: The unique name/identifier for the PURL.
    ///   - url: The target URL that the PURL should redirect to.
    /// - Throws: Network errors, validation errors, or API errors if the creation fails.
    func addPURL(
        address: String,
        name: String,
        url: String
    ) async throws

    /// Deletes an existing PURL from the remote server.
    ///
    /// This method removes a PURL with the specified name from the given address.
    /// Once deleted, the permanent URL will no longer redirect to its target URL
    /// and will become unavailable.
    ///
    /// Note: This method only handles the remote deletion. Local storage cleanup
    /// should be handled separately by the calling code.
    ///
    /// - Parameters:
    ///   - address: The address where the PURL is located.
    ///   - name: The name/identifier of the PURL to delete.
    /// - Throws: Network errors, authentication errors, or API errors if the deletion fails.
    func deletePURL(
        address: String,
        name: String
    ) async throws
}

actor PURLsNetworkService: PURLsNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol
    private let purlsStreamContinuation: AsyncStream<[PURLResponse]>.Continuation
    private let purlsAsyncStream: AsyncStream<[PURLResponse]>

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient

        let (stream, continuation) = AsyncStream<[PURLResponse]>.makeStream()
        purlsAsyncStream = stream
        purlsStreamContinuation = continuation
    }

    // MARK: - Public

    nonisolated func purlsStream() -> AsyncStream<[PURLResponse]> {
        purlsAsyncStream
    }

    func fetchPURLs(
        for address: String
    ) async throws {
        let purls = try await fetchPURLs(
            address: address
        )

        purlsStreamContinuation.yield(purls)
    }

    func addPURL(
        address: String,
        name: String,
        url: String
    ) async throws {
        _ = try await createPURL(
            address: address,
            name: name,
            url: url
        )

        let purls = try await fetchPURLs(
            address: address
        )

        purlsStreamContinuation.yield(purls)
    }

    func deletePURL(
        address: String,
        name: String
    ) async throws {
        _ = try await networkClient.run(
            PURLsRequestFactory.makeDeletePURLRequest(
                address: address,
                name: name
            )
        )
    }

    // MARK: - Private

    private func fetchPURLs(
        address: String
    ) async throws -> [PURLResponse] {
        let request = PURLsRequestFactory.makeAllPURLsRequest(
            address: address
        )

        let response = try await networkClient.run(
            request
        )

        return response.value.response.purls.map(PURLResponse.init)
    }

    private func createPURL(
        address: String,
        name: String,
        url: String
    ) async throws -> CreatePURLResponse {
        let request = PURLsRequestFactory.makeCreatePURLRequest(
            address: address,
            name: name,
            url: url
        )

        let response = try await networkClient.run(
            request
        )

        return response.value
    }
}

// MARK: - Private

private extension PURLResponse {

    /// Initializes the `PURLResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter purlResponse: The network model to be mapped.
    init(
        purlResponse: PURLsResponse.Response.PURLResponse
    ) {
        name = purlResponse.name
        url = purlResponse.url
    }
}
