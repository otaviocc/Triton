import AuthNetworkService
import AuthPersistenceService
import AuthRepository
import AuthSessionServiceInterface
import MicroClient
import MicroContainer

struct AuthEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory { container.resolve() }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        self.init(
            repositoryFactory: AuthRepositoryFactory(),
            networkServiceFactory: AuthNetworkServiceFactory(),
            persistenceServiceFactory: AuthPersistenceServiceFactory(),
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    init(
        repositoryFactory: AuthRepositoryFactoryProtocol,
        networkServiceFactory: AuthNetworkServiceFactoryProtocol,
        persistenceServiceFactory: AuthPersistenceServiceFactoryProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        container.register(
            type: (any AuthSessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            authSessionService
        }

        container.register(
            type: NetworkClientProtocol.self,
            allocation: .dynamic
        ) { _ in
            networkClient
        }

        container.register(
            type: AuthNetworkServiceProtocol.self,
            allocation: .static
        ) { container in
            networkServiceFactory
                .makeAuthNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: AuthPersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makeAuthPersistenceService(
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: AuthRepositoryProtocol.self,
            allocation: .static
        ) { container in
            repositoryFactory
                .makeAuthRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve()
                )
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
