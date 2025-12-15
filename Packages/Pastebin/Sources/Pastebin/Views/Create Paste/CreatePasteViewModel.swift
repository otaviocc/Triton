import Foundation
import Observation
import PastebinRepository
import SessionServiceInterface

@MainActor
@Observable
final class CreatePasteViewModel {

    // MARK: - Properties

    var content = ""
    var title = ""
    var selectedAddress = ""
    var isListed = false
    var shouldDismiss = false
    private(set) var addresses: [String] = []
    private(set) var isSubmitting = false

    private let repository: any PastebinRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTitle.isEmpty || trimmedContent.isEmpty || isSubmitting
    }

    var showAddressesPicker: Bool {
        !addresses.isEmpty && !selectedAddress.isEmpty
    }

    // MARK: - Lifecycle

    init(
        repository: any PastebinRepositoryProtocol,
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

    func postPaste() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.createOrUpdatePaste(
                    address: selectedAddress,
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
