import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import MicroContainer
import SessionServiceInterface
import StatusNetworkService
import StatusPersistenceService
import StatusRepository
import SwiftData

struct StatusEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as StatusRepositoryProtocol)
            .statusesContainer
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        self.init(
            repositoryFactory: StatusRepositoryFactory(),
            networkServiceFactory: StatusNetworkServiceFactory(),
            persistenceServiceFactory: StatusPersistenceServiceFactory(),
            sessionService: sessionService,
            authSessionService: authSessionService,
            networkClient: networkClient,
            clipboardService: clipboardService
        )
    }

    init(
        repositoryFactory: StatusRepositoryFactoryProtocol,
        networkServiceFactory: StatusNetworkServiceFactoryProtocol,
        persistenceServiceFactory: StatusPersistenceServiceFactoryProtocol,
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol,
        clipboardService: any ClipboardServiceProtocol
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
            type: ClipboardServiceProtocol.self,
            allocation: .static
        ) { _ in
            clipboardService
        }

        container.register(
            type: StatusNetworkServiceProtocol.self,
            allocation: .static
        ) { container in
            networkServiceFactory
                .makeStatusNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: StatusPersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makeStatusPersistenceService(
                    inMemory: false,
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: StatusRepositoryProtocol.self,
            allocation: .static
        ) { container in
            repositoryFactory
                .makeStatusRepository(
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
