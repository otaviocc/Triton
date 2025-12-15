import Foundation
import Observation
import PURLsRepository
import SessionServiceInterface

@MainActor
@Observable
final class AddPURLViewModel {

    // MARK: - Properties

    var name = ""
    var urlString = ""
    var selectedAddress = ""
    var shouldDismiss = false
    private(set) var addresses: [String] = []
    private(set) var isSubmitting = false

    private let repository: any PURLsRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let isNameEmpty = trimmedName.isEmpty
        let isURLInvalid = !urlString.hasPrefix("http://") && !urlString
            .hasPrefix("https://") || URL(string: urlString) == nil
        return isNameEmpty || isURLInvalid || isSubmitting
    }

    var showAddressesPicker: Bool {
        !addresses.isEmpty && !selectedAddress.isEmpty
    }

    // MARK: - Lifecycle

    init(
        name: String = "",
        urlString: String = "",
        repository: any PURLsRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.name = name
        self.urlString = urlString
        self.repository = repository
        self.sessionService = sessionService

        observeSessionChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func addPURL() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.addPURL(
                    address: selectedAddress,
                    name: name,
                    url: urlString
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
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
