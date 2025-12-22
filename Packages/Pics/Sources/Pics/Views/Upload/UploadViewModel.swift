import Foundation
import FoundationExtensions
import Observation
import PicsRepository
import SessionServiceInterface
import UniformTypeIdentifiers

@MainActor
@Observable
final class UploadViewModel {

    // MARK: - Properties

    var caption = ""
    var altText = ""
    var isHidden = false
    var imageData: Data?
    var selectedAddress = ""
    var tagInput = ""
    var isDragging = false
    var shouldDismiss = false
    private(set) var tags: [String] = []
    private(set) var suggestedTags: [String] = []
    private(set) var addresses: [String] = []
    private(set) var isSubmitting = false

    private let repository: any PicsRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    var isSubmitDisabled: Bool {
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedCaption.isEmpty || isSubmitting || imageData == nil
    }

    var showAddressesPicker: Bool {
        !addresses.isEmpty && !selectedAddress.isEmpty
    }

    var shouldShowProgress: Bool {
        isSubmitting
    }

    var dropZoneImageName: String {
        isDragging ? "photo.badge.plus.fill" : "photo.badge.plus"
    }

    // MARK: - Lifecycle

    init(
        repository: any PicsRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.repository = repository
        self.sessionService = sessionService

        setUpObservers()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func uploadPicture() {
        guard let data = imageData else { return }

        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.uploadPicture(
                    address: selectedAddress,
                    data: data,
                    caption: caption,
                    alt: altText,
                    isHidden: isHidden,
                    tags: tags
                )
                try await repository.fetchPictures()
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }

    func handleImageDrop(
        providers: [NSItemProvider]
    ) async -> Bool {
        guard let provider = providers.first else { return false }

        let imageTypes = provider.registeredTypeIdentifiers
            .compactMap(UTType.init)
            .filter { $0.conforms(to: .image) }

        guard let imageType = imageTypes.first else { return false }

        imageData = try? await withCheckedThrowingContinuation { continuation in
            provider.loadDataRepresentation(forTypeIdentifier: imageType.identifier) { data, _ in
                continuation.resume(returning: data)
            }
        }

        return imageData != nil
    }

    func updateTagSuggestions(
        from existingTags: [String]
    ) {
        let trimmedInput = tagInput
            .slugified()
            .lowercased()

        guard !trimmedInput.isEmpty else {
            suggestedTags = []
            return
        }

        suggestedTags = existingTags
            .filter { tag in
                tag.lowercased().contains(trimmedInput) && !tags.contains(tag)
            }
            .prefix(5)
            .map(\.self)
    }

    func addTag(_ tag: String) {
        let trimmedTag = tag.slugified()

        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else {
            tagInput = ""
            return
        }

        tags.append(trimmedTag)
        tagInput = ""
    }

    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    // MARK: - Private

    private func setUpObservers() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await session in sessionService.observeSession() {
                await MainActor.run {
                    switch session {
                    case let .session(currentAccount, selectedAddress):
                        self.handleAddresses(
                            from: currentAccount,
                            with: selectedAddress
                        )
                    default:
                        self.handleMissingAddresses()
                    }
                }
            }
        }
    }

    private func handleMissingAddresses() {
        addresses = []
        selectedAddress = ""
    }

    private func handleAddresses(
        from account: CurrentAccount,
        with selection: SelectedAddress
    ) {
        guard !account.addresses.isEmpty else {
            return handleMissingAddresses()
        }

        addresses = account.addresses.map(\.address)
        selectedAddress = selection
    }
}
