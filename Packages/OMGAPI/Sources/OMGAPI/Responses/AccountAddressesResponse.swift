public struct AccountAddressesResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: [AccountAddressResponse]
}

public extension AccountAddressesResponse {

    // MARK: - Nested types

    struct AccountAddressResponse: Decodable, Sendable {

        // MARK: - Properties

        public let address: String
        public let message: String
        public let registration: RegistrationResponse
        public let expiration: ExpirationResponse
    }
}

public extension AccountAddressesResponse.AccountAddressResponse {

    // MARK: - Nested types

    struct RegistrationResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case message
            case unixEpochTime = "unix_epoch_time"
        }

        // MARK: - Properties

        public let message: String
        public let unixEpochTime: Int
    }
}

public extension AccountAddressesResponse.AccountAddressResponse {

    // MARK: - Nested types

    struct ExpirationResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case expired
            case willExpire = "will_expire"
            case unixEpochTime = "unix_epoch_time"
        }

        // MARK: - Properties

        public let expired: Bool
        public let willExpire: Bool
        public let unixEpochTime: Int?
    }
}
