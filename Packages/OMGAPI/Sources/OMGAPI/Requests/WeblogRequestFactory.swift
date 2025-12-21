import Foundation
import FoundationExtensions
import MicroClient

/// A factory for creating weblog-related API requests.
///
/// `WeblogRequestFactory` provides static methods for creating pre-configured
/// network requests to interact with the OMG.LOL weblog API. The weblog feature
/// allows users to publish longer-form content and blog posts on their OMG.LOL
/// addresses.
///
/// This factory focuses on read operations for weblog content, providing access
/// to both individual entries and complete weblog listings for users. The weblog
/// system complements the statuslog by supporting more detailed content creation.
///
/// ## Usage Example
/// ```swift
/// // Get all weblog entries for a user
/// let entriesRequest = WeblogRequestFactory.makeAllEntriesRequest(address: "alice")
/// let entries = try await networkClient.run(entriesRequest)
///
/// // Fetch a specific weblog entry
/// let entryRequest = WeblogRequestFactory.makeWeblogIndividualEntryRequest(
///     address: "alice",
///     entryID: "my-blog-post"
/// )
/// let entry = try await networkClient.run(entryRequest)
/// ```
///
/// ## Content Access
/// Weblog entries are typically publicly accessible and do not require
/// authentication for reading. The API provides structured access to both
/// entry metadata and content.
public enum WeblogRequestFactory {

    /// Creates a request to retrieve all weblog entries for a specific user.
    ///
    /// This method builds a GET request to fetch the complete list of weblog
    /// entries published by the specified user. The response includes entry
    /// metadata such as titles, dates, and identifiers that can be used for
    /// displaying weblog indexes or navigation.
    ///
    /// Weblog entries are typically publicly accessible and do not require
    /// authentication for viewing. The entries are returned in a structured
    /// format suitable for building weblog interfaces.
    ///
    /// - Parameter address: The user address (username) whose weblog entries to retrieve
    /// - Returns: A configured network request for retrieving all weblog entries
    public static func makeAllEntriesRequest(
        address: String
    ) -> NetworkRequest<VoidRequest, WeblogEntriesResponse> {
        .init(
            path: "/address/\(address)/weblog/entries",
            method: .get
        )
    }

    /// Creates a request to fetch a specific weblog entry by ID.
    ///
    /// This method builds a GET request to retrieve a single weblog entry
    /// with its complete content and metadata. This is used for displaying
    /// individual blog posts and their full content to readers.
    ///
    /// The entry ID is typically derived from the entry's slug or identifier
    /// as provided in the weblog entries list. The response includes the
    /// complete entry content along with metadata like publication date
    /// and title information.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who published the entry
    ///   - entryID: The unique identifier or slug of the weblog entry
    /// - Returns: A configured network request for retrieving a specific weblog entry
    public static func makeWeblogIndividualEntryRequest(
        address: String,
        entryID: String
    ) -> NetworkRequest<VoidRequest, WeblogSingleEntryResponse> {
        .init(
            path: "/address/\(address)/weblog/entry/\(entryID)",
            method: .get
        )
    }

    /// Creates a request to create a new weblog entry.
    ///
    /// This method builds a POST request to create a new weblog entry with the
    /// specified content, publication date, and status. The request formats the content
    /// with frontmatter containing the date and status, then sends it as raw data to the API.
    ///
    /// The content is formatted as:
    /// ```
    /// ---
    /// Date: YYYY-MM-DD HH:MM
    /// Status: [status value]
    /// ---
    ///
    /// [content goes here]
    /// ```
    ///
    /// This request requires authentication as it creates content on behalf
    /// of the authenticated user. The API will generate a unique entry ID
    /// and URL slug based on the content title. The entry's visibility and
    /// distribution will be controlled by the specified status.
    ///
    /// - Parameters:
    ///   - address: The user address (username) to create the entry for
    ///   - content: The markdown content body of the weblog entry
    ///   - status: The publication status of the entry (e.g., "Draft", "Live", "Feed Only", "Web Only", "Unlisted")
    ///   - tags: An array of tags associated with the entry
    ///   - date: The publication date for the entry
    /// - Returns: A configured network request for creating a weblog entry
    public static func makeCreateWeblogEntryRequest(
        address: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) -> NetworkRequest<Data, CreateOrUpdateWeblogEntryResponse> {
        let body = content.weblogEntryBody(
            date: date,
            status: status,
            tags: tags
        )

        return .init(
            path: "/address/\(address)/weblog/entry",
            method: .post,
            body: body
        )
    }

    /// Creates a request to update an existing weblog entry.
    ///
    /// This method builds a POST request to update an existing weblog entry
    /// identified by its entry ID. The request formats the updated content
    /// with frontmatter containing the new date and status, then sends it as raw data.
    ///
    /// The content is formatted as:
    /// ```
    /// ---
    /// Date: YYYY-MM-DD HH:MM
    /// Status: [status value]
    /// ---
    ///
    /// [updated content goes here]
    /// ```
    ///
    /// This request requires authentication and the user must own the entry
    /// being updated. The entry's URL and slug will remain unchanged, but
    /// the content, publication date, status, and metadata will be updated
    /// with the new values.
    ///
    /// - Parameters:
    ///   - address: The user address (username) who owns the entry
    ///   - entryID: The unique identifier of the entry to update
    ///   - content: The updated markdown content body of the weblog entry
    ///   - status: The updated publication status of the entry (e.g., "Draft", "Live", "Feed Only", "Web Only",
    /// "Unlisted")
    ///   - tags: An array of tags associated with the entry
    ///   - date: The updated publication date for the entry
    /// - Returns: A configured network request for updating the weblog entry
    public static func makeUpdateWeblogEntryRequest(
        address: String,
        entryID: String,
        content: String,
        status: String,
        tags: [String],
        date: Date
    ) -> NetworkRequest<Data, CreateOrUpdateWeblogEntryResponse> {
        let body = content.weblogEntryBody(
            date: date,
            status: status,
            tags: tags
        )

        return .init(
            path: "/address/\(address)/weblog/entry/\(entryID)",
            method: .post,
            body: body
        )
    }

    /// Creates a network request to delete a specific weblog entry.
    ///
    /// - Parameters:
    ///   - address: The OMG address/domain where the weblog is hosted
    ///   - entryID: The unique identifier of the weblog entry to delete
    /// - Returns: A configured network request for deleting the weblog entry
    public static func makeDeleteWeblogEntryRequest(
        address: String,
        entryID: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/address/\(address)/weblog/delete/\(entryID)",
            method: .delete
        )
    }
}
