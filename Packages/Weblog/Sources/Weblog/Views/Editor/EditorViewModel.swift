import Foundation
import Observation
import WeblogRepository

@MainActor
@Observable
final class EditorViewModel {

    // MARK: - Properties

    var body: String
    var entryID: String?
    var date: Date
    var selectedStatus: WeblogEntryStatus
    var shouldDismiss = false
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
        repository: any WeblogRepositoryProtocol
    ) {
        self.address = address
        self.body = body
        self.date = date
        self.entryID = entryID
        selectedStatus = status
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
                    date: date
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }
}
