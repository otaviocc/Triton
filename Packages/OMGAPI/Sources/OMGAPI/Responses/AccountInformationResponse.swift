public struct AccountInformationResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension AccountInformationResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let email: String
        public let name: String
        public let created: Created
    }
}

public extension AccountInformationResponse.Response {

    // MARK: - Nested types

    struct Created: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case unixEpochTime = "unix_epoch_time"
        }

        // MARK: - Properties

        public let unixEpochTime: Int
    }
}
