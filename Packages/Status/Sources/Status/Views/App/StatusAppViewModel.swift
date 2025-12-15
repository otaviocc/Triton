import AuthSessionServiceInterface
import Foundation
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class StatusAppViewModel {

    // MARK: - Properties

    private(set) var disableComposeButton = true

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.authSessionService = authSessionService
        self.sessionService = sessionService

        observeSessionChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Private

    private func observeSessionChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            let initialLoggedIn = await authSessionService.isLoggedIn
            var hasAddresses = false

            let accountTask = Task { [weak self] in
                guard let self else { return }
                for await account in sessionService.observeAccount() {
                    let hasAddr: Bool = switch account {
                    case .notSynchronized:
                        false
                    case let .account(current):
                        !current.addresses.isEmpty
                    }

                    hasAddresses = hasAddr
                    let isLoggedIn = await authSessionService.isLoggedIn
                    await MainActor.run {
                        self.disableComposeButton = !isLoggedIn || !hasAddresses
                    }
                }
            }

            disableComposeButton = !initialLoggedIn || !hasAddresses

            for await isLoggedIn in authSessionService.observeLoginState() {
                disableComposeButton = !isLoggedIn || !hasAddresses
            }

            accountTask.cancel()
        }
    }
}
