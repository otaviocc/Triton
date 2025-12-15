public struct UpdateNowPageRequest: Encodable, Sendable {

    // MARK: - Properties

    let content: String
    let listed: Int

    // MARK: - Lifecycle

    init(
        content: String,
        listed: Int
    ) {
        self.content = content
        self.listed = listed
    }
}
