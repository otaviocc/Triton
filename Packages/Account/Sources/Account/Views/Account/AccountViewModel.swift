import Observation
import SessionServiceInterface

@MainActor
@Observable
final class AccountViewModel {

    // MARK: - Properties

    private(set) var account: Account = .notSynchronized

    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        sessionService: any SessionServiceProtocol
    ) {
        self.sessionService = sessionService

        setUpObservers()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Private

    private func setUpObservers() {
        observationTask = Task { [weak self] in
            guard let self else { return }
            for await account in sessionService.observeAccount() {
                await MainActor.run {
                    self.account = account
                }
            }
        }
    }
}
