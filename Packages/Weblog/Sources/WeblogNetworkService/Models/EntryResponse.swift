import Foundation

/// A response model representing a weblog entry fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code.
/// It contains all the essential information about a weblog entry, transformed from the
/// raw API response into a client-friendly format.
///
/// The model conforms to `Identifiable` for use in SwiftUI lists and collections,
/// `Equatable` for value comparison, and `Sendable` for safe concurrent usage.
public struct EntryResponse: Identifiable, Equatable, Sendable {

    /// The unique identifier of the weblog entry.
    ///
    /// This identifier is used for referencing specific entries across the system
    /// and is guaranteed to be unique within the scope of a weblog address.
    public let id: String

    /// The URL slug/path segment for the weblog entry.
    ///
    /// This represents the human-readable URL component that identifies the entry
    /// within the weblog structure (e.g., "my-first-post" in "/weblog/my-first-post").
    public let location: String

    /// The publication date of the weblog entry as a Unix timestamp.
    ///
    /// This timestamp represents when the entry was published and is used for
    /// chronological sorting and display formatting.
    public let date: Double

    /// The publication status of the weblog entry.
    ///
    /// Common values include "published", "draft", or other status indicators
    /// that control the entry's visibility and behavior.
    public let status: String

    /// The title of the weblog entry.
    ///
    /// This is the main heading or title text that identifies the entry to readers.
    /// It's typically displayed prominently in lists and at the top of the entry content.
    public let title: String

    /// The main content body of the weblog entry.
    ///
    /// This contains the primary text content of the entry, which may include
    /// formatted text, HTML, or other content markup depending on the weblog system.
    public let body: String

    /// The address where the weblog entry is hosted.
    ///
    /// This identifies which weblog/address the entry belongs to, enabling
    /// multi-address support within the same application instance.
    public let address: String

    // MARK: - Public

    public init(
        id: String,
        location: String,
        date: Double,
        status: String,
        title: String,
        body: String,
        address: String
    ) {
        self.id = id
        self.location = location
        self.date = date
        self.status = status
        self.title = title
        self.body = body
        self.address = address
    }
}
