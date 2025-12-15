import Foundation
import Observation
import SessionServiceInterface
import StatusRepository

@MainActor
@Observable
final class PostStatusViewModel {

    // MARK: - Properties

    var content: String
    var emoji: String
    var selectedAddress = ""
    var shouldDismiss = false
    private(set) var addresses: [String] = []
    private(set) var isSubmitting = false

    private let repository: StatusRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var status: String {
        "\(content.count) characters"
    }

    var isSubmitDisabled: Bool {
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    var showAddressesPicker: Bool {
        !addresses.isEmpty && !selectedAddress.isEmpty
    }

    // MARK: - Lifecycle

    init(
        content: String = "",
        emoji: String,
        repository: StatusRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.content = content
        self.emoji = emoji
        self.repository = repository
        self.sessionService = sessionService

        observeSessionChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func postStatus() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.postStatus(
                    address: selectedAddress,
                    emoji: emoji,
                    content: content
                )
                try await repository.fetchStatuses()
                shouldDismiss = true
            } catch {
                // Error handled, isSubmitting set to false in defer
            }
        }
    }

    // MARK: - Private

    private func observeSessionChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await session in sessionService.observeSession() {
                await MainActor.run {
                    switch session {
                    case let .session(currentAccount, selectedAddress):
                        self.handleAddresses(from: currentAccount, with: selectedAddress)
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
