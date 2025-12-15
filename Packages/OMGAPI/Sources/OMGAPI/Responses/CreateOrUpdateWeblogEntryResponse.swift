public struct CreateOrUpdateWeblogEntryResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension CreateOrUpdateWeblogEntryResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        public let message: String
        public let entry: CreateWeblogEntry
    }
}

public extension CreateOrUpdateWeblogEntryResponse.Response {

    // MARK: - Nested types

    struct CreateWeblogEntry: Decodable, Sendable {

        // MARK: - Properties

        public let location: String
        public let title: String
        public let date: Double
        public let type: String
        public let status: String
        public let body: String
        public let source: String
        public let output: String
        public let entry: String
    }
}
