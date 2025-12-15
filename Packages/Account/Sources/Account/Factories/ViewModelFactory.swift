import MicroContainer
import SessionServiceInterface
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
    func makeAccountViewModel() -> AccountViewModel {
        .init(
            sessionService: container.resolve()
        )
    }

    @MainActor
    func makeAccountDetailsViewModel(
        currentAccount: CurrentAccount
    ) -> AccountDetailsViewModel {
        .init(
            currentAccount: currentAccount,
            sessionService: container.resolve()
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
