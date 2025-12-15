import Foundation

@MainActor
final class NowViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let markdown: String
    let timestamp: Double
    let listed: Bool
    let address: String
    let isCurrent: Bool

    var publishedDate: String {
        Date(timeIntervalSince1970: timestamp)
            .formatted(
                date: .abbreviated, time: .shortened
            )
    }

    // MARK: - Lifecycle

    init(
        markdown: String,
        timestamp: Double,
        listed: Bool,
        address: String,
        isCurrent: Bool
    ) {
        self.markdown = markdown
        self.timestamp = timestamp
        self.listed = listed
        self.address = address
        self.isCurrent = isCurrent
    }
}
