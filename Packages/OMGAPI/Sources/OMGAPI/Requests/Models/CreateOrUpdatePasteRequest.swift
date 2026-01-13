public struct CreateOrUpdatePasteRequest: Encodable, Sendable {

    // MARK: - Properties

    let title: String
    let content: String
    let listed: Bool
}
