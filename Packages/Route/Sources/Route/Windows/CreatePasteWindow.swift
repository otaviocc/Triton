import Foundation

/// Window configuration for creating a new paste.
///
/// `CreatePasteWindow` defines the window identifier and display name
/// for the paste creation interface.
public enum CreatePasteWindow {

    public static let name = "Paste"
    public static let id = "create-paste-window"
}

/// Parameters for opening a paste creation window.
///
/// `CreatePaste` is an empty parameter struct used to trigger
/// the paste creation window. All configuration happens within the window itself.
public struct CreatePaste: Codable, Hashable {

    // MARK: - Lifecycle

    public init() {}
}
