import AuthSessionServiceInterface
import Observation
import SwiftUI

@MainActor
@Observable
final class SidebarViewModel {

    // MARK: - Properties

    private(set) var showLogoutButton = false

    private let authSessionService: any AuthSessionServiceProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.authSessionService = authSessionService

        observeLoginState()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Private

    private func observeLoginState() {
        observationTask = Task { @MainActor in
            for await isLoggedIn in authSessionService.observeLoginState() {
                showLogoutButton = isLoggedIn
            }
        }
    }
}
