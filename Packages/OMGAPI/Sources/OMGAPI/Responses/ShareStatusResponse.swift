import Foundation

public struct ShareStatusResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension ShareStatusResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case message
            case id
            case status
            case url
            case externalURL = "external_url"
        }

        // MARK: - Properties

        public let message: String
        public let id: String
        public let status: String
        public let url: URL
        public let externalURL: URL?
    }
}
