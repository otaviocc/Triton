public struct AccessTokenResponse: Decodable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }

    // MARK: - Properties

    public let accessToken: String
    public let tokenType: String
    public let scope: String
}
