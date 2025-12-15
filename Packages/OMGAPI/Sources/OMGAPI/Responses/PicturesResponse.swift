public struct PicturesResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension PicturesResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let pics: [PictureResponse]
    }
}

public extension PicturesResponse.Response {

    // MARK: - Nested types

    struct PictureResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case id
            case address
            case created
            case mime
            case size
            case url
            case somePicsURL = "some_pics_url"
            case description
            case alt
            case tags
        }

        public let id: String
        public let address: String
        public let created: Double
        public let mime: String
        public let size: Double
        public let url: String
        public let somePicsURL: String
        public let description: String?
        public let alt: String?
        public let tags: [String]
    }
}
