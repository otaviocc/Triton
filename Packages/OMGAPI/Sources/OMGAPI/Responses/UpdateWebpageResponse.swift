public struct UpdateWebpageResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension UpdateWebpageResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
    }
}
