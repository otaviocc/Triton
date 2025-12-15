public struct RequestResponse: Decodable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case statusCode = "status_code"
        case success
    }

    // MARK: - Properties

    public let statusCode: Int
    public let success: Bool
}
