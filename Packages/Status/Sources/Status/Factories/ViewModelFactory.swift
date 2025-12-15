import MicroContainer
import StatusPersistenceService
import StatusRepository
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
    func makeStatusListViewModel(
        filter: StatusListFilter
    ) -> StatusListViewModel {
        .init(
            filter: filter
        )
    }

    @MainActor
    func makeStatusViewModel(
        status: Status
    ) -> StatusViewModel {
        .init(
            status: status,
            repository: container.resolve(),
            clipboardService: container.resolve()
        )
    }

    @MainActor
    func makeProfileViewModel(
        address: String
    ) -> ProfileViewModel {
        .init(
            address: address
        )
    }

    @MainActor
    func makeStatusAppViewModel() -> StatusAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve()
        )
    }

    @MainActor
    func makePostStatusViewModel(
        content: String = "",
        emoji: String
    ) -> PostStatusViewModel {
        .init(
            content: content,
            emoji: emoji,
            repository: container.resolve(),
            sessionService: container.resolve()
        )
    }

    @MainActor
    func makeStatusSettingsViewModel() -> StatusSettingsViewModel {
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
