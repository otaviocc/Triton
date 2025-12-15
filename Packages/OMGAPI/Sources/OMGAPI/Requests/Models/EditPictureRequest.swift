import Foundation

public struct EditPictureRequest: Encodable, Sendable {

    // MARK: - Properties

    let caption: String?
    let alt: String?
    let isHidden: Bool?
    let tags: String?

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case caption = "description"
        case alt = "alt_text"
        case isHidden = "hide_from_public"
        case tags
    }

    // MARK: - Lifecycle

    init(
        caption: String?,
        alt: String?,
        isHidden: Bool?,
        tags: String?
    ) {
        self.caption = caption
        self.alt = alt
        self.tags = tags

        // Workaround a known issue where sending `false`
        // also hides the photo from public.
        self.isHidden = isHidden == true ? true : nil
    }
}
