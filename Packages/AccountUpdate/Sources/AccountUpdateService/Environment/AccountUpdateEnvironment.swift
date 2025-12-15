import AccountUpdateNetworkService
import AccountUpdatePersistenceService
import AccountUpdateRepository
import AuthSessionServiceInterface
import MicroClient
import MicroContainer
import SessionServiceInterface

struct AccountUpdateEnvironment {

    // MARK: - Properties

    var accountUpdateRepository: AccountUpdateRepositoryProtocol {
        container.resolve()
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        self.init(
            sessionService: sessionService,
            authSessionService: authSessionService,
            networkClient: networkClient,
            networkServiceFactory: AccountUpdateNetworkServiceFactory(),
            persistenceServiceFactory: AccountUpdatePersistenceServiceFactory(),
            serviceFactory: AccountUpdateRepositoryFactory()
        )
    }

    init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol,
        networkServiceFactory: AccountUpdateNetworkServiceFactoryProtocol,
        persistenceServiceFactory: AccountUpdatePersistenceServiceFactoryProtocol,
        serviceFactory: AccountUpdateRepositoryFactoryProtocol
    ) {
        container.register(
            type: (any SessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            sessionService
        }

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
            type: AccountUpdateNetworkServiceProtocol.self,
            allocation: .static
        ) { container in
            networkServiceFactory
                .makeAccountUpdateNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: AccountUpdatePersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makeAccountUpdatePersistenceService(
                    sessionService: container.resolve(),
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: AccountUpdateRepositoryProtocol.self,
            allocation: .static
        ) { container in
            serviceFactory
                .makeAccountUpdateRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve(),
                    authSessionService: container.resolve()
                )
        }
    }
}
