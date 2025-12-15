import ClipboardService
import Foundation
import FoundationExtensions
import StatusPersistenceService
import StatusRepository

@MainActor
final class StatusViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let address: String
    let message: String
    let icon: String
    let statusURL: URL
    let timestamp: Double
    let replyURL: URL?

    var backgroundColorID: Int {
        Int(timestamp)
    }

    var relativeDate: String {
        Date(timeIntervalSince1970: timestamp)
            .formatted(
                .relative(presentation: .numeric)
            )
    }

    private let repository: StatusRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        status: Status,
        repository: StatusRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        address = status.username
        message = status.content
        timestamp = status.timestamp
        icon = status.icon
        statusURL = URL(statusID: status.statusID, for: status.username)
        replyURL = status.externalURL
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        address: String,
        message: String,
        icon: String,
        statusURL: URL,
        timestamp: Double,
        replyURL: URL?,
        repository: StatusRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.address = address
        self.message = message
        self.icon = icon
        self.statusURL = statusURL
        self.timestamp = timestamp
        self.replyURL = replyURL
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func muteAddress() {
        let address = address.trimmingCharacters(in: .whitespacesAndNewlines)

        Task {
            try? await repository.muteAddress(address: address)
        }
    }

    func copyStatusURLToClipboard() {
        clipboardService.copy(
            statusURL.absoluteString
        )
    }

    func copyReplyURLToClipboard() {
        guard let replyURL else { return }

        clipboardService.copy(
            replyURL.absoluteString
        )
    }
}
