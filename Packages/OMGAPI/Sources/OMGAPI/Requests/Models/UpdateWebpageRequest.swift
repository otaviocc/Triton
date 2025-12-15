public struct UpdateWebpageRequest: Encodable, Sendable {

    // MARK: - Properties

    let content: String
    let publish: Bool

    // MARK: - Lifecycle

    init(
        content: String,
        publish: Bool
    ) {
        self.content = content
        self.publish = publish
    }
}
