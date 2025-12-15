import MicroContainer
import SessionServiceInterface

struct AccountEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        sessionService: any SessionServiceProtocol
    ) {
        container.register(
            type: (any SessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            sessionService
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
