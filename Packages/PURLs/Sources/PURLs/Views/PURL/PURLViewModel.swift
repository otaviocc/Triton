import ClipboardService
import Foundation
import FoundationExtensions
import PURLsPersistenceService
import PURLsRepository

@MainActor
final class PURLViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let title: String
    let originalURL: URL
    let permanentURL: URL
    let address: String

    private let repository: any PURLsRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        title: String,
        originalURL: URL,
        permanentURL: URL,
        address: String,
        repository: any PURLsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.title = title
        self.originalURL = originalURL
        self.permanentURL = permanentURL
        self.address = address
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        purl: PURL,
        repository: any PURLsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        title = purl.name
        originalURL = purl.url
        permanentURL = URL(purlName: title, for: purl.address)
        address = purl.address

        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPURLToClipboard() {
        clipboardService.copy(
            permanentURL.absoluteString
        )
    }

    func copyMarkdownToClipboard() {
        let markdown = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdown)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePURL(
                address: address,
                name: title
            )
        }
    }
}
