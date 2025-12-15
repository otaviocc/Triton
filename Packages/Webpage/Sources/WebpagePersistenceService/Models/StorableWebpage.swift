import Foundation

/// A data transfer object for webpage content intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models for webpage content. It's designed to be easily convertible
/// from `WebResponse` objects and into `Webpage` SwiftData models.
///
/// The model contains all essential webpage data needed for local storage, including
/// the content, modification timestamp, and associated address. It's used by the
/// persistence service to create or update database records with versioned content.
///
/// The model conforms to `Sendable` for safe usage across different concurrency contexts.
public struct StorableWebpage: Sendable {

    // MARK: - Properties

    /// The markdown content of the webpage.
    ///
    /// This contains the full webpage content that will be stored locally.
    /// The content is preserved exactly as received from the network layer
    /// to maintain consistency between remote and local storage.
    let markdownContent: String

    /// The timestamp when the webpage was last modified.
    ///
    /// This timestamp represents the server-side modification time and is used
    /// for versioning and chronological sorting in the local database.
    /// It enables the persistence layer to maintain a history of content changes.
    let timestamp: Double

    /// The address associated with the webpage.
    ///
    /// This identifies which webpage the content belongs to, enabling proper
    /// data organization and multi-address support in local storage.
    /// Combined with the timestamp, it forms a unique identifier for versioning.
    let address: String

    // MARK: - Lifecycle

    /// Initializes a new storable webpage with all required content and metadata.
    ///
    /// This initializer is typically used when converting from network response
    /// models during the data synchronization process, or when creating webpage
    /// objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - markdownContent: The webpage content in markdown format.
    ///   - timestamp: The last modification timestamp as Unix time.
    ///   - address: The domain address associated with the webpage.
    public init(
        markdownContent: String,
        timestamp: Double,
        address: String
    ) {
        self.markdownContent = markdownContent
        self.timestamp = timestamp
        self.address = address
    }
}
