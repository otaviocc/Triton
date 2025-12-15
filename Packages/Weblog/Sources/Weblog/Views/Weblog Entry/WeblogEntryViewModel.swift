import ClipboardService
import Foundation
import FoundationExtensions
import WeblogRepository

@MainActor
final class WeblogEntryViewModel: Identifiable {

    // MARK: - Properties

    let id: String
    let title: String
    let body: String
    let status: String
    let timestamp: Double
    let address: String
    let location: String

    var publishedDate: Date {
        Date(timeIntervalSince1970: timestamp)
    }

    var formattedDate: String {
        publishedDate
            .formatted(
                date: .abbreviated, time: .omitted
            )
    }

    var permanentURL: URL {
        URL(
            weblogPostFor: address,
            location: location
        )
    }

    var isLive: Bool {
        status == "live"
    }

    private let repository: any WeblogRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        id: String,
        title: String,
        body: String,
        status: String,
        timestamp: Double,
        address: String,
        location: String,
        repository: any WeblogRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.status = status
        self.timestamp = timestamp
        self.address = address
        self.location = location
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyEntryURLToClipboard() {
        clipboardService.copy(
            permanentURL.absoluteString
        )
    }

    func copyMarkdownLinkToClipboard() {
        let markdownLink = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdownLink)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deleteEntry(
                address: address,
                entryID: id
            )
        }
    }
}
