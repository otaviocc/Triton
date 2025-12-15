import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to pastebin functionality.
///
/// This protocol defines the interface for managing text pastes on a remote server,
/// providing functionality to create, fetch, update, and delete text snippets.
/// Pastebin functionality allows users to store and share text content with optional
/// public/private visibility settings.
///
/// The protocol supports both streaming updates for real-time synchronization and individual
/// CRUD operations for paste management. It handles communication with the pastebin API and
/// provides data transformation from API responses to client-friendly models.
public protocol PastebinNetworkServiceProtocol: AnyObject, Sendable {

    /// Provides a stream of paste collection updates.
    ///
    /// This method returns an AsyncStream that emits arrays of `PasteResponse` objects
    /// whenever paste collections are fetched or modified. This enables reactive UI updates
    /// and real-time synchronization between network operations and local storage.
    ///
    /// The stream emits updates when pastes are fetched, ensuring that observers
    /// receive the most current paste collection state.
    ///
    /// - Returns: An `AsyncStream<[PasteResponse]>` that emits paste collection updates.
    func pastesStream() -> AsyncStream<[PasteResponse]>

    /// Fetches all pastes for a specific address and emits them through the stream.
    ///
    /// This method retrieves all pastes associated with the given address from the
    /// remote server and emits the results through the pastes stream. The fetched
    /// pastes include both public and private content owned by the address.
    ///
    /// - Parameter address: The address to fetch pastes for.
    /// - Throws: Network errors, API errors, or decoding errors if the fetch operation fails.
    func fetchPastes(
        for address: String
    ) async throws

    /// Creates a new paste or updates an existing one on the remote server.
    ///
    /// This method creates a new text paste with the specified title and content,
    /// or updates an existing paste if one with the same title already exists.
    /// The paste visibility can be controlled through the listed parameter.
    ///
    /// The paste title serves as the unique identifier within the address scope,
    /// so providing an existing title will update that paste's content rather
    /// than creating a duplicate.
    ///
    /// - Parameters:
    ///   - address: The address where the paste should be created or updated.
    ///   - title: The unique title/identifier for the paste.
    ///   - content: The text content of the paste.
    ///   - listed: Whether the paste should be publicly visible (true) or private (false).
    /// - Throws: Network errors, validation errors, or API errors if the operation fails.
    func createOrUpdatePaste(
        address: String,
        title: String,
        content: String,
        listed: Bool
    ) async throws

    /// Deletes an existing paste from the remote server.
    ///
    /// This method removes a paste with the specified title from the given address.
    /// Once deleted, the paste content will no longer be accessible and cannot
    /// be recovered through the API.
    ///
    /// Note: This method only handles the remote deletion. Local storage cleanup
    /// should be handled separately by the calling code.
    ///
    /// - Parameters:
    ///   - address: The address where the paste is located.
    ///   - title: The title/identifier of the paste to delete.
    /// - Throws: Network errors, authentication errors, or API errors if the deletion fails.
    func deletePaste(
        address: String,
        title: String
    ) async throws
}

actor PastebinNetworkService: PastebinNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol
    private let pastesStreamContinuation: AsyncStream<[PasteResponse]>.Continuation
    private let pastesAsyncStream: AsyncStream<[PasteResponse]>

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient

        let (stream, continuation) = AsyncStream<[PasteResponse]>.makeStream()
        pastesAsyncStream = stream
        pastesStreamContinuation = continuation
    }

    // MARK: - Public

    nonisolated func pastesStream() -> AsyncStream<[PasteResponse]> {
        pastesAsyncStream
    }

    func fetchPastes(
        for address: String
    ) async throws {
        let pastes = try await fetchPastes(
            address: address
        )

        pastesStreamContinuation.yield(pastes)
    }

    func createOrUpdatePaste(
        address: String,
        title: String,
        content: String,
        listed: Bool
    ) async throws {
        _ = try await networkClient.run(
            PastebinRequestFactory.makeCreateOrUpdatePasteRequest(
                address: address,
                title: title,
                content: content,
                isListed: listed
            )
        )
    }

    func deletePaste(
        address: String,
        title: String
    ) async throws {
        _ = try await networkClient.run(
            PastebinRequestFactory.makeDeletePasteRequest(
                address: address,
                title: title
            )
        )
    }

    // MARK: - Private

    private func fetchPastes(
        address: String
    ) async throws -> [PasteResponse] {
        let request = PastebinRequestFactory.makePastesRequest(
            address: address
        )

        let response = try await networkClient.run(
            request
        )

        return response.value.response.pastebin.map(PasteResponse.init)
    }
}

// MARK: - Private

private extension PasteResponse {

    /// Initializes the `PasteResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter pasteResponse: The network model to be mapped.
    init(
        pasteResponse: PastesResponse.Response.PasteResponse
    ) {
        content = pasteResponse.content
        title = pasteResponse.title
        modifiedOn = pasteResponse.modifiedOn
        listed = pasteResponse.listed == 1
    }
}
