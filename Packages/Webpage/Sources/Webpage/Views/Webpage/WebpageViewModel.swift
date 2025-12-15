import Foundation

@MainActor
final class WebpageViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let markdown: String
    let timestamp: Double
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
        address: String,
        isCurrent: Bool
    ) {
        self.markdown = markdown
        self.timestamp = timestamp
        self.address = address
        self.isCurrent = isCurrent
    }
}
