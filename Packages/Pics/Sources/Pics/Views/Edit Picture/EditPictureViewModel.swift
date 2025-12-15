import Foundation
import FoundationExtensions
import Observation
import PicsRepository

@MainActor
@Observable
final class EditPictureViewModel {

    // MARK: - Properties

    let pictureID: String
    var caption = ""
    var altText = ""
    var tagInput = ""
    var shouldDismiss = false
    private(set) var tags: [String] = []
    private(set) var suggestedTags: [String] = []
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any PicsRepositoryProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    var shouldShowProgress: Bool {
        isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        caption: String = "",
        altText: String = "",
        tags: [String] = [],
        pictureID: String = "",
        repository: any PicsRepositoryProtocol
    ) {
        self.address = address
        self.caption = caption
        self.altText = altText
        self.tags = tags
        self.pictureID = pictureID
        self.repository = repository
    }

    // MARK: - Public

    func updatePicture() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.updatePicture(
                    address: address,
                    pictureID: pictureID,
                    caption: caption,
                    alt: altText,
                    tags: tags
                )
                try await repository.fetchPictures()
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
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
}
