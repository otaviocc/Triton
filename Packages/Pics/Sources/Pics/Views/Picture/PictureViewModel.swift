import ClipboardService
import Foundation
import FoundationExtensions
import PicsRepository

@MainActor
final class PictureViewModel: Identifiable {

    // MARK: - Properties

    let id: String
    let title: String?
    let altText: String?
    let photoURL: URL?
    let somePicsURL: URL?
    let timestamp: Double
    let address: String
    let tags: [String]

    var markdownLink: String? {
        somePicsURL?.markdownFormatted(title: title)
    }

    var markdownImage: String? {
        photoURL?.markdownFormatted(title: altText, isImage: true)
    }

    private let repository: any PicsRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        id: String,
        timestamp: Double,
        title: String? = nil,
        altText: String? = nil,
        photoURL: URL? = nil,
        somePicsURL: URL? = nil,
        address: String,
        tags: [String] = [],
        repository: any PicsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.id = id
        self.timestamp = timestamp
        self.title = title
        self.altText = altText
        self.photoURL = photoURL
        self.somePicsURL = somePicsURL
        self.address = address
        self.tags = tags
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPhotoURLToClipboard() {
        guard let photoURL else { return }

        clipboardService.copy(
            photoURL.absoluteString
        )
    }

    func copySomePicsURLToClipboard() {
        guard let somePicsURL else { return }

        clipboardService.copy(
            somePicsURL.absoluteString
        )
    }

    func copyMarkdownLinkToClipboard() {
        guard let markdownLink else { return }

        clipboardService.copy(markdownLink)
    }

    func copyMarkdownImageToClipboard() {
        guard let markdownImage else { return }

        clipboardService.copy(markdownImage)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePicture(
                address: address,
                pictureID: id
            )
        }
    }
}
