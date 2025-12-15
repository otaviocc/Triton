import Foundation
import Observation
import SessionServiceInterface
import WebpageRepository

@MainActor
@Observable
final class EditorViewModel {

    // MARK: - Properties

    let viewTitle = "Web Page"
    var content: String
    var shouldDismiss = false
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any WebpageRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        content: String = "",
        repository: any WebpageRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.address = address
        self.content = content
        self.repository = repository
        self.sessionService = sessionService
    }

    // MARK: - Public

    func publishWebpage() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.updateWebpage(
                    address: address,
                    content: content
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }
}
