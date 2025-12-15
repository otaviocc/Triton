public struct CreatePURLRequest: Encodable, Sendable {

    // MARK: - Properties

    let address: String
    let name: String
    let url: String

    // MARK: - Lifecycle

    init(
        address: String,
        name: String,
        url: String
    ) {
        self.address = address
        self.name = name
        self.url = url
    }
}
