import Foundation

/// Window configuration for editing a weblog entry.
///
/// `EditWeblogEntryWindow` defines the window identifier and display name
/// for the weblog entry editing interface.
public enum EditWeblogEntryWindow {

    public static let name = "Weblog Entry Editor"
    public static let id = "edit-weblog-entry-window"
}

/// Parameters for opening a weblog entry editor window.
///
/// `EditWeblogEntry` contains all the information needed to populate the weblog editor
/// with existing entry content for modification.
public struct EditWeblogEntry: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the weblog entry is hosted.
    public let address: String

    /// The content/body of the weblog entry.
    public let body: String

    /// The publication date of the weblog entry.
    public let date: Date

    /// The unique identifier for the weblog entry, if it already exists.
    public let entryID: String?

    /// The publication status of the weblog entry.
    public let status: String?

    // MARK: - Lifecycle

    public init(
        address: String,
        body: String,
        date: Date,
        entryID: String?,
        status: String?
    ) {
        self.address = address
        self.body = body
        self.date = date
        self.entryID = entryID
        self.status = status
    }
}
