import Foundation

/// Window configuration for composing a new status update.
///
/// `ComposeWindow` defines the window identifier and display name
/// for the status composition interface.
public enum ComposeWindow {

    public static let name = "Status"
    public static let id = "compose-window"
}

/// Parameters for opening a status composition window.
///
/// `ComposeStatus` contains the information needed to pre-populate
/// the status composition form with initial content.
public struct ComposeStatus: Codable, Hashable {

    // MARK: - Properties

    /// The text content of the status update.
    public let message: String

    /// An optional emoji to accompany the status update.
    public let emoji: String?

    // MARK: - Lifecycle

    public init(
        message: String,
        emoji: String? = nil
    ) {
        self.message = message
        self.emoji = emoji
    }
}
