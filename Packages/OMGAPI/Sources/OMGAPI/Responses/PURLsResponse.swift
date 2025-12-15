import Foundation

public struct PURLsResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension PURLsResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let purls: [PURLResponse]
    }
}

public extension PURLsResponse.Response {

    // MARK: - Nested types

    struct PURLResponse: Decodable, Sendable {

        // MARK: - Properties

        public let name: String
        public let url: URL
        public let counter: Int?
    }
}
