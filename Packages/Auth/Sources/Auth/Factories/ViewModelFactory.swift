import AuthRepository
import Foundation
import MicroContainer
import SwiftUI

final class ViewModelFactory: Sendable {

    // MARK: - Properties

    private let container: DependencyContainer

    // MARK: - Lifecycle

    init(
        container: DependencyContainer
    ) {
        self.container = container
    }

    // MARK: - Public

    @MainActor
    func makeAuthAppViewModel() -> AuthAppViewModel {
        .init(
            authSessionService: container.resolve()
        )
    }

    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        .init(
            repository: container.resolve()
        )
    }

    @MainActor
    func makeLogoutViewModel() -> LogoutViewModel {
        .init(
            repository: container.resolve()
        )
    }
}

// MARK: - Environment

extension EnvironmentValues {

    @Entry var viewModelFactory: ViewModelFactory = .placeholder
}

extension ViewModelFactory {

    static let placeholder = ViewModelFactory(
        container: .init()
    )
}
