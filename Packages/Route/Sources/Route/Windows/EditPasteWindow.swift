import Foundation

/// Window configuration for editing an existing paste.
///
/// `EditPasteWindow` defines the window identifier and display name
/// for the paste editing interface.
public enum EditPasteWindow {

    public static let name = "Paste Editor"
    public static let id = "edit-paste-window"
}

/// Parameters for opening a paste editor window.
///
/// `EditPaste` contains all the information needed to populate the paste editor
/// with existing paste content for modification.
public struct EditPaste: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the paste is hosted.
    public let address: String

    /// The title of the paste.
    public let title: String

    /// The main content/body of the paste.
    public let content: String

    /// Whether the paste should be publicly listed or unlisted.
    public let isListed: Bool

    // MARK: - Lifecycle

    public init(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) {
        self.address = address
        self.title = title
        self.content = content
        self.isListed = isListed
    }
}
