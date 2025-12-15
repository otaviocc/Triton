import AuthRepository
import Observation
import SwiftUI

@MainActor
@Observable
final class LogoutViewModel {

    // MARK: - Properties

    private let repository: AuthRepositoryProtocol

    // MARK: - Lifecycle

    init(
        repository: AuthRepositoryProtocol
    ) {
        self.repository = repository
    }

    // MARK: - Public

    func logout() {
        Task {
            await repository.removeAccessToken()
        }
    }
}
