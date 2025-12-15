import Foundation

/// A data transfer object for status updates intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models for status timeline data. It's designed to be easily convertible
/// from `StatusResponse` objects and into `Status` SwiftData models.
///
/// The model contains all essential status update data needed for local storage,
/// representing a single status update from a user with its associated metadata.
/// It's used by the persistence service to create or update database records that
/// maintain the current status for each user in the timeline.
///
/// The model conforms to `Sendable` for safe usage across different concurrency contexts.
public struct StorableStatus: Sendable {

    // MARK: - Properties

    /// The unique identifier of the status update.
    ///
    /// This identifier corresponds to the server-side status ID and is used
    /// for tracking and referencing specific status updates across the system.
    let id: String

    /// The username (address) of the user who posted the status.
    ///
    /// This represents the user's address within the OMG network and is used
    /// as the primary identifier for organizing status updates by user in
    /// local storage. The unique constraint on username ensures only the
    /// latest status per user is maintained.
    let username: String

    /// The publication timestamp of the status update as a Unix timestamp.
    ///
    /// This represents when the status update was published and is stored
    /// as a Double for efficient sorting and date calculations in the
    /// local database.
    let timestamp: Double

    /// The emoji icon associated with the status update.
    ///
    /// This emoji provides visual context for the status and is displayed
    /// prominently in the timeline UI to give users quick visual cues
    /// about the status content or mood.
    let icon: String

    /// The markdown content of the status update.
    ///
    /// This contains the full text content of the status update, including
    /// any markdown formatting, which will be persisted locally for
    /// offline access and timeline display.
    let content: String

    /// An optional external URL for interacting with the status.
    ///
    /// This URL enables external interaction with the status update,
    /// such as replying or viewing additional context outside the app.
    /// It's preserved in local storage for future reference.
    let externalURL: URL?

    // MARK: - Lifecycle

    /// Initializes a new storable status with all required status update data.
    ///
    /// This initializer is typically used when converting from network response
    /// models during the data synchronization process, or when creating status
    /// objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the status update.
    ///   - username: The username/address of the user who posted the status.
    ///   - timestamp: The publication timestamp as Unix time.
    ///   - icon: The emoji icon associated with the status.
    ///   - content: The markdown content of the status update.
    ///   - externalURL: An optional URL for external interaction with the status.
    public init(
        id: String,
        username: String,
        timestamp: Double,
        icon: String,
        content: String,
        externalURL: URL?
    ) {
        self.id = id
        self.username = username
        self.timestamp = timestamp
        self.icon = icon
        self.content = content
        self.externalURL = externalURL
    }
}
