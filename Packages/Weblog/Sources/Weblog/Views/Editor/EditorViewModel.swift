import Foundation
import FoundationExtensions
import Observation
import WeblogRepository

@MainActor
@Observable
final class EditorViewModel {

    // MARK: - Properties

    var body: String
    var entryID: String?
    var date: Date
    var status: WeblogEntryStatus
    var tagInput = ""
    var shouldDismiss = false
    private(set) var tags: [String] = []
    private(set) var suggestedTags: [String] = []
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any WeblogRepositoryProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    var isTextEditorDisabled: Bool {
        isSubmitting
    }

    var shouldShowProgress: Bool {
        isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        body: String,
        date: Date,
        entryID: String?,
        status: WeblogEntryStatus,
        tags: [String],
        repository: any WeblogRepositoryProtocol
    ) {
        self.address = address
        self.body = body
        self.date = date
        self.entryID = entryID
        self.status = status
        self.tags = tags
        self.repository = repository
    }

    // MARK: - Public

    func publishWeblogEntry() {
        Task {
            isSubmitting = true

            defer { isSubmitting = false }

            do {
                try await repository.createOrUpdateEntry(
                    address: address,
                    entryID: entryID,
                    body: body,
                    status: status.rawValue,
                    tags: tags,
                    date: date
                )
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
