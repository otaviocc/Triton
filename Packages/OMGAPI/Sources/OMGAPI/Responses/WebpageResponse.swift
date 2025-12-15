public struct WebpageResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension WebpageResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let content: String
        public let type: String
        public let theme: String
        public let css: String
        public let head: String
        public let verified: Int
        public let pfp: String
        public let metadata: String
        public let branding: String
        public let modified: String
    }
}
