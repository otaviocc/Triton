import Foundation

/// Window configuration for uploading a new picture.
///
/// `UploadPictureWindow` defines the window identifier and display name
/// for the picture upload interface.
public enum UploadPictureWindow {

    public static let name = "Picture"
    public static let id = "upload-picture--window"
}

/// Parameters for opening a picture upload window.
///
/// `UploadPicture` is an empty parameter struct used to trigger
/// the picture upload window. All configuration happens within the window itself.
public struct UploadPicture: Codable, Hashable {

    // MARK: - Lifecycle

    public init() {}
}
