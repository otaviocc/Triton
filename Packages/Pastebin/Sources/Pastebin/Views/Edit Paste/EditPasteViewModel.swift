import Foundation
import Observation
import PastebinRepository

@MainActor
@Observable
final class EditPasteViewModel {

    // MARK: - Properties

    var title: String
    var content: String
    var isListed: Bool
    var shouldDismiss = false
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any PastebinRepositoryProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        title: String,
        content: String,
        isListed: Bool,
        repository: any PastebinRepositoryProtocol
    ) {
        self.address = address
        self.title = title
        self.content = content
        self.isListed = isListed
        self.repository = repository
    }

    // MARK: - Public

    func publishPaste() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.createOrUpdatePaste(
                    address: address,
                    title: title,
                    content: content,
                    isListed: isListed
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }
}
