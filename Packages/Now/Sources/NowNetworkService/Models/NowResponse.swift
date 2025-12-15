import Foundation

/// A response model representing a /now page fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code
/// for /now page operations. It represents the content and metadata of a /now page,
/// which is a concept from nownownow.com where people share what they're currently
/// focused on in their lives.
///
/// The /now page contains markdown content that describes what someone is currently
/// working on, thinking about, or focused on, along with metadata about when it was
/// last updated and its visibility in public directories or "gardens."
///
/// The model conforms to `Equatable` for value comparison and `Sendable` for safe
/// concurrent usage across different actors and isolation domains.
public struct NowResponse: Equatable, Sendable {

    // MARK: - Properties

    /// The markdown content of the /now page.
    ///
    /// This contains the full /now page content in markdown format, representing
    /// what the person is currently focused on in their life. The content can
    /// include text, links, and other markdown formatting to describe current
    /// projects, thoughts, or life focus areas.
    public let markdownContent: String

    /// The timestamp when the /now page was last modified as a Unix timestamp.
    ///
    /// This represents when the /now page content was last updated on the server
    /// and is used for versioning, conflict resolution, and displaying last-modified
    /// information to users. It reflects the server-side modification time.
    public let updated: Int

    /// An integer flag indicating if the /now page is listed in public directories.
    ///
    /// This integer value indicates the visibility status of the /now page:
    /// - Non-zero values typically indicate the page is publicly listed in directories or "gardens"
    /// - Zero typically indicates the page is private and not discoverable publicly
    ///
    /// The integer format is preserved from the API response for compatibility.
    public let listed: Int

    // MARK: - Lifecycle

    /// Initializes a new /now page response with content and metadata.
    ///
    /// This initializer is typically used when converting from network response
    /// models or when creating response objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - markdownContent: The /now page content in markdown format.
    ///   - updated: The last modification timestamp as Unix time.
    ///   - listed: An integer flag indicating public visibility status.
    public init(
        markdownContent: String,
        updated: Int,
        listed: Int
    ) {
        self.markdownContent = markdownContent
        self.updated = updated
        self.listed = listed
    }
}
