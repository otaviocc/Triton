import Foundation
import SwiftData

/// A SwiftData model representing a status update stored in the local database.
///
/// This model is the persistent representation of status updates in the app's local storage.
/// It's designed to maintain a "current status per user" cache of the social timeline,
/// storing only the most recent status update for each user rather than a complete history.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities and
/// includes unique constraints on username to ensure only one status per user is stored.
/// This design provides an efficient way to display the current status of users in
/// the social network without consuming excessive storage space.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<Status>.makeDefault()
/// let statuses = try modelContext.fetch(descriptor)
/// ```
@Model
public final class Status {

    // MARK: - Properties

    /// The username (address) of the user who posted the status update.
    ///
    /// This serves as the unique identifier for status updates in the database,
    /// ensuring that only one status per user is maintained. When a new status
    /// for the same user is stored, it replaces the previous one.
    public private(set) var username: String

    /// The unique identifier of the status update from the server.
    ///
    /// This corresponds to the server-side status ID and is preserved for
    /// reference purposes, though the username serves as the primary key
    /// for local storage uniqueness.
    public private(set) var statusID: String

    /// The publication timestamp of the status update as a Unix timestamp.
    ///
    /// This timestamp is used for chronological sorting of status updates
    /// in the timeline, with more recent updates appearing first. It represents
    /// when the status was originally published on the server.
    public private(set) var timestamp: Double

    /// The emoji icon associated with the status update.
    ///
    /// This emoji provides visual context and emotional expression for the
    /// status update. It's displayed prominently in the timeline UI to give
    /// users immediate visual cues about the status content or mood.
    public private(set) var icon: String

    /// The markdown content of the status update.
    ///
    /// This contains the full text content of the status update, including
    /// any markdown formatting. The content is stored locally to enable
    /// offline access to the social timeline.
    public private(set) var content: String

    /// An optional external URL for interacting with the status update.
    ///
    /// This URL enables external interaction with the status, such as
    /// replying through a web interface or accessing additional context
    /// outside the application.
    public private(set) var externalURL: URL?

    // MARK: - Unique constraints

    /// Ensures only one status update per username is stored in the database.
    ///
    /// This constraint implements the "current status per user" storage model,
    /// automatically replacing older status updates when new ones arrive for
    /// the same user, maintaining an efficient and current view of the social timeline.
    #Unique<Status>([\.username])

    // MARK: - Lifecycle

    /// Initializes a new status update with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorableStatus` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - username: The username/address of the user who posted the status.
    ///   - statusID: The unique server-side identifier of the status update.
    ///   - timestamp: The publication timestamp as Unix time.
    ///   - icon: The emoji icon associated with the status.
    ///   - content: The markdown content of the status update.
    ///   - externalURL: An optional URL for external interaction with the status.
    public init(
        username: String,
        statusID: String,
        timestamp: Double,
        icon: String,
        content: String,
        externalURL: URL? = nil
    ) {
        self.username = username
        self.statusID = statusID
        self.timestamp = timestamp
        self.icon = icon
        self.content = content
        self.externalURL = externalURL
    }

    // MARK: - Public

    /// Determines whether this status update should be filtered from display based on mute settings.
    ///
    /// This method checks if the status should be hidden from the timeline by evaluating
    /// two filtering criteria:
    /// 1. Whether the status author's username is in the muted addresses set
    /// 2. Whether any muted keyword appears in the status content (case-insensitive)
    ///
    /// The filtering logic returns `true` (should be filtered) if either condition is met,
    /// allowing users to hide unwanted content based on both source and content criteria.
    ///
    /// - Parameters:
    ///   - mutedAddresses: A set of user addresses that should be filtered from the timeline.
    ///   - mutedKeywords: An array of keywords that, when found in content, trigger filtering.
    /// - Returns: `true` if the status should be filtered (hidden), `false` if it should be displayed.
    public func shouldFilter(
        mutedAddresses: Set<String>,
        mutedKeywords: [String]
    ) -> Bool {
        if mutedAddresses.contains(username) {
            return true
        }

        return mutedKeywords.contains { keyword in
            content.lowercased().contains(keyword.lowercased())
        }
    }
}
