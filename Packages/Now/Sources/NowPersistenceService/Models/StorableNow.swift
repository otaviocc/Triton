import Foundation

/// A data transfer object for /now pages intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models for /now page data. It's designed to be easily convertible
/// from `NowResponse` objects and into `Now` SwiftData models.
///
/// The model contains all essential /now page data needed for local storage, including
/// the markdown content, metadata, visibility settings, and synchronization state.
/// It's used by the persistence service to create or update database records that
/// maintain the user's /now page history with version tracking.
///
/// The /now page represents what someone is currently focused on in their life,
/// following the concept from nownownow.com.
public struct StorableNow {

    // MARK: - Properties

    /// The markdown content of the /now page.
    ///
    /// This contains the full /now page content describing what the person is
    /// currently focused on in their life. The content is preserved exactly as
    /// received from the network layer to maintain consistency between remote
    /// and local storage.
    let markdownContent: String

    /// The last modification timestamp as a Unix timestamp.
    ///
    /// This represents when the /now page was last modified on the server and is
    /// used for versioning and chronological sorting in the local database.
    /// It enables the persistence layer to maintain a history of /now page changes.
    let timestamp: Double

    /// Whether the /now page is listed in public directories or "gardens."
    ///
    /// This boolean indicates the visibility status of the /now page. When true,
    /// the page is publicly discoverable in directories. When false, it remains
    /// private to the owner. This setting is stored locally for offline management.
    let listed: Bool

    /// Whether the /now page has been synchronized with the remote server.
    ///
    /// This boolean tracks the synchronization state of the /now page:
    /// - true: The content has been successfully submitted/synchronized with the server
    /// - false: The content is saved locally but may not be synchronized with the server
    ///
    /// This enables offline editing capabilities and sync status tracking.
    let submitted: Bool

    /// The address associated with the /now page.
    ///
    /// This identifies which user address the /now page belongs to, enabling proper
    /// data organization and multi-address support in local storage. Combined with
    /// the timestamp, it forms a unique identifier for versioning.
    let address: String

    // MARK: - Lifecycle

    /// Initializes a new storable /now page with all required data and metadata.
    ///
    /// This initializer is typically used when converting from network response
    /// models during the data synchronization process, or when creating /now page
    /// objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - markdownContent: The /now page content in markdown format.
    ///   - timestamp: The last modification timestamp as Unix time.
    ///   - listed: Whether the /now page is publicly visible in directories.
    ///   - submitted: Whether the content has been synchronized with the server.
    ///   - address: The user address associated with the /now page.
    public init(
        markdownContent: String,
        timestamp: Double,
        listed: Bool,
        submitted: Bool,
        address: String
    ) {
        self.markdownContent = markdownContent
        self.timestamp = timestamp
        self.listed = listed
        self.submitted = submitted
        self.address = address
    }
}
