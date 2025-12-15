import Foundation

public struct StatuslogStatusResponse: Decodable, Identifiable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case id
        case address
        case created
        case relativeTime = "relative_time"
        case emoji
        case content
        case externalURL = "external_url"
    }

    // MARK: - Properties

    public let id: String
    public let address: String
    public let created: String
    public let relativeTime: String
    public let emoji: String
    public let content: String
    public let externalURL: URL?

    // MARK: - Lifecycle

    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        id = try container.decode(
            String.self,
            forKey: .id
        )

        address = try container.decode(
            String.self,
            forKey: .address
        )

        created = try container.decode(
            String.self,
            forKey: .created
        )

        relativeTime = try container.decode(
            String.self,
            forKey: .relativeTime
        )

        emoji = try container.decode(
            String.self,
            forKey: .emoji
        )

        content = try container.decode(
            String.self,
            forKey: .content
        )

        externalURL = try container
            .decodeIfPresent(
                String.self,
                forKey: .externalURL
            )
            .flatMap(URL.init(string:))
    }
}
