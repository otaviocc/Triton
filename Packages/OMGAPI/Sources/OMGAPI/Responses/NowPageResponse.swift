public struct NowPageResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension NowPageResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let now: NowResponse
    }
}

public extension NowPageResponse.Response {

    // MARK: - Nested types

    struct NowResponse: Decodable, Sendable {

        // MARK: - Properties

        public let content: String
        public let updated: Int
        public let listed: Int
    }
}
