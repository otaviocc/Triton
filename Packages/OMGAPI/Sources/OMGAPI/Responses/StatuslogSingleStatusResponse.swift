public struct StatuslogSingleStatusResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension StatuslogSingleStatusResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let status: StatuslogStatusResponse
    }
}
