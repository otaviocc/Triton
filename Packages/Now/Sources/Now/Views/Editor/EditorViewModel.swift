import Foundation
import NowRepository
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class EditorViewModel {

    // MARK: - Properties

    let viewTitle = "Now Page"
    var content: String
    var isListed = false
    var shouldDismiss = false
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any NowRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        content: String = "",
        isListed: Bool,
        repository: any NowRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.address = address
        self.content = content
        self.isListed = isListed
        self.repository = repository
        self.sessionService = sessionService
    }

    // MARK: - Public

    func publishNowPage() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.updateNowPage(
                    address: address,
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
