public struct WeblogEntryResponse: Decodable, Identifiable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case id = "entry"
        case address
        case location
        case title
        case date
        case type
        case status
        case source
        case body
        case output
        case metadata
    }

    // MARK: - Properties

    public let id: String
    public let address: String
    public let location: String
    public let title: String
    public let date: Double
    public let type: String
    public let status: String
    public let source: String
    public let body: String
    public let output: String
    public let metadata: String
}
