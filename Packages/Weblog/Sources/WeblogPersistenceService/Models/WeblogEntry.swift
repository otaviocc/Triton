import Foundation
import SwiftData

/// A SwiftData model representing a weblog entry stored in the local database.
///
/// This model is the persistent representation of weblog entries in the app's local storage.
/// It's designed to support offline access, caching, and synchronization with remote data.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities and
/// includes unique constraints to prevent duplicate entries. All properties are publicly
/// readable but privately settable to maintain data integrity.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<WeblogEntry>.makeDefault()
/// let entries = try modelContext.fetch(descriptor)
/// ```
@Model
public final class WeblogEntry {

    // MARK: - Properties

    /// The unique identifier of the weblog entry.
    ///
    /// This serves as the primary key for the database and is used to ensure
    /// uniqueness across all stored entries. It corresponds to the server-side
    /// identifier for synchronization purposes.
    public private(set) var id: String

    /// The title of the weblog entry.
    ///
    /// This is the main heading text displayed to users in lists and detail views.
    /// The title is indexed by SwiftData for efficient searching and filtering.
    public private(set) var title: String

    /// The main content body of the weblog entry.
    ///
    /// This contains the full text content of the entry, including any formatting
    /// or markup. The content is stored locally to enable offline reading capabilities.
    public private(set) var body: String

    /// The publication date of the weblog entry as a Unix timestamp.
    ///
    /// This timestamp is used for chronological sorting and date-based queries.
    /// It represents when the entry was originally published, not when it was
    /// stored locally.
    public private(set) var date: Double

    /// The publication status of the weblog entry.
    ///
    /// This indicates the entry's current state (e.g., "published", "draft") and
    /// can be used for filtering entries based on their publication status.
    public private(set) var status: String

    /// The URL slug/path segment for the weblog entry.
    ///
    /// This represents the human-readable URL component and is used for
    /// generating proper URLs when navigating to or sharing entries.
    public private(set) var location: String

    /// The address where the weblog entry is hosted.
    ///
    /// This identifies which weblog the entry belongs to, enabling support
    /// for multiple weblogs within the same app instance.
    public private(set) var address: String

    /// An array of tags associated with the weblog entry for categorization and discovery.
    ///
    /// These user-defined tags enable content organization, filtering, and search
    /// functionality. Tags can be used to group related entries or identify
    /// specific themes, events, or characteristics of the content. The array may
    /// be empty if no tags have been assigned to the entry.
    ///
    /// This property is optional to support migration from older database schemas
    /// that didn't include tags. When nil, it should be treated as an empty array.
    public private(set) var tags: [String]?

    // MARK: - Unique constraints

    /// Ensures each entry has a unique identifier in the database.
    ///
    /// This constraint prevents duplicate entries from being stored and enables
    /// efficient updates when synchronizing with remote data.
    #Unique<WeblogEntry>([\.id])

    // MARK: - Lifecycle

    /// Initializes a new weblog entry with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorableEntry` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the entry.
    ///   - title: The entry's title text.
    ///   - content: The main content body of the entry.
    ///   - date: The publication date as a Unix timestamp.
    ///   - status: The publication status of the entry.
    ///   - location: The URL slug for the entry.
    ///   - address: The domain where the entry is hosted.
    ///   - tags: An optional array of tags associated with the entry. Defaults to nil (treated as empty array).
    public init(
        id: String,
        title: String,
        body: String,
        date: Double,
        status: String,
        location: String,
        address: String,
        tags: [String]? = nil
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
