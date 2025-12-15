import AuthSessionServiceInterface
import Observation
import SwiftUI

@MainActor
@Observable
final class AuthAppViewModel {

    // MARK: - Properties

    private(set) var isLoggedIn = false

    private let authSessionService: any AuthSessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.authSessionService = authSessionService

        observationTask = Task { @MainActor in
            let currentState = await authSessionService.isLoggedIn
            isLoggedIn = currentState

            for await loginState in authSessionService.observeLoginState() {
                if isLoggedIn != loginState {
                    isLoggedIn = loginState
                }
            }
        }
    }

    deinit {
        observationTask?.cancel()
    }
}
