import ClipboardService
import Foundation
import FoundationExtensions
import PastebinPersistenceService
import PastebinRepository

@MainActor
final class PasteViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let title: String
    let content: String
    let address: String
    let listed: Bool

    var permanentURL: URL {
        URL(pasteTitle: title, for: address)
    }

    var isPublic: Bool {
        listed
    }

    private let repository: any PastebinRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        title: String,
        content: String,
        listed: Bool,
        address: String,
        repository: any PastebinRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.title = title
        self.content = content
        self.address = address
        self.listed = listed
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        paste: Paste,
        repository: any PastebinRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        title = paste.title
        content = paste.content
        listed = paste.listed
        address = paste.address

        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPasteURLToClipboard() {
        clipboardService.copy(permanentURL.absoluteString)
    }

    func copyMarkdownLinkToClipboard() {
        let markdownLink = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdownLink)
    }

    func copyMarkdownCodeBlockToClipboard() {
        clipboardService.copy(content.markdownFormattedCodeBlock())
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePaste(
                address: address,
                title: title
            )
        }
    }
}
