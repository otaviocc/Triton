import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to weblog entries.
///
/// This protocol defines the interface for fetching weblog entries from a remote server.
/// Implementations should handle network communication and data transformation from
/// the API response format to the client-friendly `EntryResponse` model.
public protocol WeblogNetworkServiceProtocol: AnyObject, Sendable {

    /// Fetches all weblog entries for a specific address.
    ///
    /// This method retrieves all published weblog entries associated with the given address.
    /// The entries are returned in the order provided by the server, typically sorted by
    /// publication date.
    ///
    /// - Parameter address: The address to fetch weblog entries for.
    /// - Returns: An array of `EntryResponse` objects representing the weblog entries.
    /// - Throws: Network errors, decoding errors, or API-specific errors.
    func fetchWeblogEntries(
        for address: String
    ) async throws -> [EntryResponse]

    /// Fetches a specific weblog entry by its identifier.
    ///
    /// This method retrieves a single weblog entry using its unique identifier.
    /// Use this method when you need detailed information about a specific entry
    /// or when working with individual entry operations.
    ///
    /// - Parameters:
    ///   - address: The address where the entry is published.
    ///   - entryID: The unique identifier of the entry to fetch.
    /// - Returns: An `EntryResponse` object representing the requested weblog entry.
    /// - Throws: Network errors, decoding errors, or API-specific errors if the entry is not found.
    func fetchWeblogEntry(
        for address: String,
        entryID: String
    ) async throws -> EntryResponse

    /// Creates a new weblog entry for the specified address.
    ///
    /// This method sends a POST request to the OMG.LOL API to create a new weblog entry.
    /// The content is formatted with frontmatter including the publication date, status,
    /// and sent as raw data to the API endpoint.
    ///
    /// The request requires authentication and will create a new entry with a
    /// system-generated unique identifier. The entry will be immediately available
    /// at the user's weblog URL according to the specified status.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to create the entry for
    ///   - content: The markdown content body of the weblog entry
    ///   - status: The publication status of the entry (e.g., "Draft", "Live", "Feed Only", "Web Only", "Unlisted")
    ///   - tags: An array of tags associated with the entry
    ///   - date: The publication date for the entry
    /// - Returns: The created weblog entry with metadata and generated ID
    /// - Throws: Network errors, authentication errors, or API-specific errors.
    func createWeblogEntry(
        address: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) async throws -> EntryResponse

    /// Updates an existing weblog entry with new content.
    ///
    /// This method sends a POST request to the OMG.LOL API to update an existing
    /// weblog entry identified by its entry ID. The content is formatted with
    /// frontmatter including the updated publication date, status, and sent as raw data.
    ///
    /// The request requires authentication and the user must own the entry being
    /// updated. The entry's URL and slug will remain unchanged, but the content,
    /// publication date, status, and metadata will be updated.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who owns the entry
    ///   - entryID: The unique identifier of the entry to update
    ///   - content: The updated markdown content body of the weblog entry
    ///   - status: The updated publication status of the entry (e.g., "Draft", "Live", "Feed Only", "Web Only",
    /// "Unlisted")
    ///   - tags: An array of tags associated with the entry
    ///   - date: The updated publication date for the entry
    /// - Returns: The updated weblog entry with new content and metadata
    /// - Throws: Network errors, authentication errors, or API-specific errors if the entry is not found.
    func updateWeblogEntry(
        address: String,
        entryID: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) async throws -> EntryResponse

    /// Deletes a specific weblog entry from the server.
    ///
    /// - Parameters:
    ///   - address: The OMG address/domain where the weblog is hosted
    ///   - entryID: The unique identifier of the weblog entry to delete
    /// - Throws: Network or API errors if the deletion fails
    func deleteWeblogEntry(
        address: String,
        entryID: String
    ) async throws
}

actor WeblogNetworkService: WeblogNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient
    }

    // MARK: - Public

    func fetchWeblogEntries(
        for address: String
    ) async throws -> [EntryResponse] {
        let response = try await networkClient.run(
            WeblogRequestFactory.makeAllEntriesRequest(address: address)
        )

        return response.value.response.entries
            .filter { $0.type == "post" }
            .map(EntryResponse.init)
    }

    func fetchWeblogEntry(
        for address: String,
        entryID: String
    ) async throws -> EntryResponse {
        let response = try await networkClient.run(
            WeblogRequestFactory.makeWeblogIndividualEntryRequest(
                address: address,
                entryID: entryID
            )
        )

        return EntryResponse(
            weblogEntryResponse: response.value.response.entry
        )
    }

    func createWeblogEntry(
        address: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) async throws -> EntryResponse {
        let response = try await networkClient.run(
            WeblogRequestFactory.makeCreateWeblogEntryRequest(
                address: address,
                content: content,
                status: status,
                tags: tags,
                date: date
            )
        )

        return EntryResponse(
            address: address,
            createWeblogEntryResponse: response.value.response.entry
        )
    }

    func updateWeblogEntry(
        address: String,
        entryID: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) async throws -> EntryResponse {
        let response = try await networkClient.run(
            WeblogRequestFactory.makeUpdateWeblogEntryRequest(
                address: address,
                entryID: entryID,
                content: content,
                status: status,
                tags: tags,
                date: date
            )
        )

        return EntryResponse(
            address: address,
            createWeblogEntryResponse: response.value.response.entry
        )
    }

    func deleteWeblogEntry(
        address: String,
        entryID: String
    ) async throws {
        _ = try await networkClient.run(
            WeblogRequestFactory.makeDeleteWeblogEntryRequest(
                address: address,
                entryID: entryID
            )
        )
    }
}

// MARK: - Private

private extension EntryResponse {

    /// Initializes the `WeblogEntryResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// - Parameter weblogEntryResponse: The network model to be mapped.
    init(
        weblogEntryResponse: WeblogEntryResponse
    ) {
        id = weblogEntryResponse.id
        location = weblogEntryResponse.location
        date = weblogEntryResponse.date
        status = weblogEntryResponse.status
        title = weblogEntryResponse.title
        body = weblogEntryResponse.body
        address = weblogEntryResponse.address
        tags = weblogEntryResponse.tags
    }
}

private extension EntryResponse {

    /// Initializes the `CreateWeblogEntryResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// Tags not returned in create/update response, will be synced on next fetch.
    ///
    /// - Parameter createWeblogEntryResponse: The network model to be mapped.
    init(
        address: String,
        createWeblogEntryResponse: CreateOrUpdateWeblogEntryResponse.Response.CreateWeblogEntry
    ) {
        id = createWeblogEntryResponse.entry
        location = createWeblogEntryResponse.location
        date = createWeblogEntryResponse.date
        status = createWeblogEntryResponse.status
        title = createWeblogEntryResponse.title
        body = createWeblogEntryResponse.body
        tags = .init()
        self.address = address
    }
}
