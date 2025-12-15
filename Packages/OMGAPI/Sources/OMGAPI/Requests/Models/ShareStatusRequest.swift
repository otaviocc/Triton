public struct ShareStatusRequest: Encodable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case emoji
        case content
        case externalURLString = "external_url"
    }

    // MARK: - Properties

    let emoji: String
    let content: String
    let externalURLString: String?

    // MARK: - Lifecycle

    init(
        emoji: String,
        content: String,
        externalURLString: String? = nil
    ) {
        self.emoji = emoji
        self.content = content
        self.externalURLString = externalURLString
    }
}
