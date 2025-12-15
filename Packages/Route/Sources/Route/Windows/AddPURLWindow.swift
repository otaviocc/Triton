import Foundation

/// Window configuration for adding a new PURL (Permanent URL).
///
/// `AddPURLWindow` defines the window identifier and display name
/// for the PURL creation interface.
public enum AddPURLWindow {

    public static let name = "PURL"
    public static let id = "add-purl-window"
}

/// Parameters for opening a PURL creation window.
///
/// `AddPURL` is an empty parameter struct used to trigger
/// the PURL creation window. All configuration happens within the window itself.
public struct AddPURL: Codable, Hashable {

    // MARK: - Public

    public init() {}
}
