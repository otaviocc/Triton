import Foundation

/// Window configuration for editing picture metadata.
///
/// `EditPictureWindow` defines the window identifier and display name
/// for the picture editing interface.
public enum EditPictureWindow {

    public static let name = "Picture Editor"
    public static let id = "edit-picture-window"
}

/// Parameters for opening a picture editor window.
///
/// `EditPicture` contains all the information needed to populate the picture editor
/// with existing metadata for modification.
public struct EditPicture: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the picture is hosted.
    public let address: String

    /// The unique identifier of the picture being edited.
    public let pictureID: String

    /// An optional caption describing the picture.
    public let caption: String?

    /// Optional alternative text for accessibility.
    public let altText: String?

    /// Optional array of tags for categorizing the picture.
    public let tags: [String]?

    // MARK: - Lifecycle

    public init(
        address: String,
        pictureID: String,
        caption: String?,
        altText: String?,
        tags: [String]?
    ) {
        self.address = address
        self.pictureID = pictureID
        self.caption = caption
        self.altText = altText
        self.tags = tags
    }
}
