import Foundation

/// Window configuration for editing a user's now page.
///
/// `EditNowPageWindow` defines the window identifier and display name
/// for the now page editing interface.
public enum EditNowPageWindow {

    public static let name = "Now Page Editor"
    public static let id = "edit-now-window"
}

/// Parameters for opening a now page editor window.
///
/// `EditNowPage` contains all the information needed to populate the now page editor
/// with existing content for modification.
public struct EditNowPage: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the now page is hosted.
    public let address: String

    /// The main content/body of the now page.
    public let content: String

    /// Whether the now page should be publicly listed or unlisted.
    public let isListed: Bool

    // MARK: - Lifecycle

    public init(
        address: String,
        content: String,
        isListed: Bool
    ) {
        self.address = address
        self.content = content
        self.isListed = isListed
    }
}
