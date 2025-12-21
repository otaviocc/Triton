import Foundation

/// A data transfer object for weblog entries intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models. It's designed to be easily convertible from `EntryResponse`
/// objects and into `WeblogEntry` SwiftData models.
///
/// The model contains all the essential weblog entry data needed for local storage
/// and is used by the persistence service to create or update database records.
public struct StorableEntry {

    // MARK: - Properties

    /// The unique identifier of the weblog entry.
    ///
    /// This identifier is used to uniquely identify entries in the database
    /// and is typically the primary key for persistence operations.
    let id: String

    /// The title of the weblog entry.
    ///
    /// This is the main heading text that will be displayed to users
    /// and stored in the local database for offline access.
    let title: String

    /// The main content body of the weblog entry.
    ///
    /// This contains the full text content of the entry, including any
    /// formatting or markup, which will be persisted locally.
    let body: String

    /// The publication date of the weblog entry as a Unix timestamp.
    ///
    /// This timestamp is used for chronological sorting in the database
    /// and for displaying publication dates to users.
    let date: Double

    /// The publication status of the weblog entry.
    ///
    /// This indicates the entry's current state (e.g., "published", "draft")
    /// and affects how it's displayed and managed in the local storage.
    let status: String

    /// The URL slug/path segment for the weblog entry.
    ///
    /// This represents the human-readable URL component that identifies
    /// the entry and is stored locally for offline URL generation.
    let location: String

    /// The address where the weblog entry is hosted.
    ///
    /// This identifies which weblog the entry belongs to, enabling
    /// proper data organization and multi-address support in local storage.
    let address: String

    /// An array of tags associated with the weblog entry for categorization and discovery.
    ///
    /// These user-defined tags enable content organization, filtering, and search
    /// functionality. Tags can be used to group related entries or identify
    /// specific themes, events, or characteristics of the content. The array may
    /// be empty if no tags have been assigned to the entry.
    let tags: [String]

    // MARK: - Lifecycle

    /// Initializes a new storable entry with all required weblog entry data.
    ///
    /// This initializer is typically used when converting from network response
    /// models or when creating entries programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the entry.
    ///   - title: The entry's title text.
    ///   - content: The main content body of the entry.
    ///   - date: The publication date as a Unix timestamp.
    ///   - status: The publication status of the entry.
    ///   - location: The URL slug for the entry.
    ///   - address: The domain where the entry is hosted.
    ///   - tags: An array of tags associated with the entry. Defaults to empty array.
    public init(
        id: String,
        title: String,
        body: String,
        date: Double,
        status: String,
        location: String,
        address: String,
        tags: [String]
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.status = status
        self.location = location
        self.address = address
        self.tags = tags
    }
}
