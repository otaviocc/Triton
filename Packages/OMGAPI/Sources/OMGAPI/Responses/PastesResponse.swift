public struct PastesResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: Response
}

public extension PastesResponse {

    // MARK: - Nested types

    struct Response: Decodable, Sendable {

        // MARK: - Properties

        public let message: String
        public let pastebin: [PasteResponse]
    }
}

public extension PastesResponse.Response {

    // MARK: - Nested types

    struct PasteResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case title
            case content
            case modifiedOn = "modified_on"
            case listed
        }

        // MARK: - Properties

        public let title: String
        public let content: String
        public let modifiedOn: Int
        public let listed: Int

        // MARK: - Lifecycle

        public init(
            from decoder: Decoder
        ) throws {
            let container = try decoder.container(
                keyedBy: CodingKeys.self
            )

            title = try container.decode(
                String.self,
                forKey: .title
            )

            content = try container.decode(
                String.self,
                forKey: .content
            )

            modifiedOn = try container.decode(
                Int.self,
                forKey: .modifiedOn
            )

            let listed = try? container.decode(
                Int.self,
                forKey: .listed
            )
            self.listed = listed ?? 0
        }
    }
}
