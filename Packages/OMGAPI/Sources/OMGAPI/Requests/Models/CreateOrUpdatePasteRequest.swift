public struct CreateOrUpdatePasteRequest: Encodable, Sendable {

    // MARK: - Properties

    let title: String
    let content: String
    let listed: Bool

    // MARK: - Lifecycle

    init(
        title: String,
        content: String,
        listed: Bool
    ) {
        self.title = title
        self.content = content
        self.listed = listed
    }
}
