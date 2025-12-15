import Foundation
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class AccountDetailsViewModel {

    // MARK: - Properties

    let currentAccount: CurrentAccount
    private(set) var selectedAddress: String?

    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        currentAccount: CurrentAccount,
        sessionService: any SessionServiceProtocol
    ) {
        self.currentAccount = currentAccount
        self.sessionService = sessionService

        setUpObservers()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func selectAddress(
        _ address: String
    ) {
        Task {
            await sessionService.setSelectedAddress(
                address
            )
        }
    }

    // MARK: - Private

    private func setUpObservers() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await address in sessionService.observeAddress() {
                let selected: String? = switch address {
                case let .address(current):
                    current
                default:
                    nil
                }

                await MainActor.run {
                    self.selectedAddress = selected
                }
            }
        }
    }
}
