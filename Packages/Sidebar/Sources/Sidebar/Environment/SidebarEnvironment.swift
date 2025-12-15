import AuthSessionServiceInterface
import MicroContainer

struct SidebarEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        container.register(
            type: (any AuthSessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            authSessionService
        }

        container.register(
            type: ViewModelFactory.self,
            allocation: .static
        ) { container in
            ViewModelFactory(
                container: container
            )
        }
    }
}
