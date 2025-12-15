import Foundation

/// Window configuration for editing a webpage.
///
/// `EditWebpageWindow` defines the window identifier and display name
/// for the webpage editing interface.
public enum EditWebpageWindow {

    public static let name = "Webpage Editor"
    public static let id = "edit-webpage-window"
}

/// Parameters for opening a webpage editor window.
///
/// `EditWebpage` contains all the information needed to populate the webpage editor
/// with existing content for modification.
public struct EditWebpage: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the webpage is hosted.
    public let address: String

    /// The HTML/content of the webpage.
    public let content: String

    // MARK: - Lifecycle

    public init(
        address: String,
        content: String
    ) {
        self.address = address
        self.content = content
    }
}
