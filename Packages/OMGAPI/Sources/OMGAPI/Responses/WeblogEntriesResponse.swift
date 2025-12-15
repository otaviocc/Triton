public struct WeblogEntriesResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension WeblogEntriesResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let entries: [WeblogEntryResponse]
    }
}
