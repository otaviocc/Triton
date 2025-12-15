import MicroContainer
import PURLsPersistenceService
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
    func makePURLsAppViewModel() -> PURLsAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makePURLsListViewModel(
        address: SelectedAddress,
        sort: PURLsListSort
    ) -> PURLsListViewModel {
        .init(
            address: address,
            sort: sort,
            repository: container.resolve()
        )
    }

    @MainActor
    func makePURLViewModel(
        purl: PURL
    ) -> PURLViewModel {
        .init(
            purl: purl,
            repository: container.resolve(),
            clipboardService: container.resolve()
        )
    }

    @MainActor
    func makeAddPURLViewModel() -> AddPURLViewModel {
        .init(
            repository: container.resolve(),
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
