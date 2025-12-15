import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import MicroContainer
import PicsNetworkService
import PicsPersistenceService
import PicsRepository
import SessionServiceInterface
import SwiftData

struct PicsEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as any PicsRepositoryProtocol)
            .picturesContainer
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        self.init(
            networkServiceFactory: PicsNetworkServiceFactory(),
            persistenceServiceFactory: PicsPersistenceServiceFactory(),
            repositoryFactory: PicsRepositoryFactory(),
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService,
            clipboardService: clipboardService
        )
    }

    init(
        networkServiceFactory: PicsNetworkServiceFactoryProtocol,
        persistenceServiceFactory: PicsPersistenceServiceFactoryProtocol,
        repositoryFactory: PicsRepositoryFactoryProtocol,
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        container.register(
            type: (any SessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            sessionService
        }

        container.register(
            type: NetworkClientProtocol.self,
            allocation: .dynamic
        ) { _ in
            networkClient
        }

        container.register(
            type: (any AuthSessionServiceProtocol).self,
            allocation: .dynamic
        ) { _ in
            authSessionService
        }

        container.register(
            type: ClipboardServiceProtocol.self,
            allocation: .static
        ) { _ in
            clipboardService
        }

        container.register(
            type: ViewModelFactory.self,
            allocation: .static
        ) { container in
            ViewModelFactory(
                container: container
            )
        }

        container.register(
            type: (any PicsNetworkServiceProtocol).self,
            allocation: .dynamic
        ) { container in
            networkServiceFactory.makePicsNetworkService(
                networkClient: container.resolve()
            )
        }

        container.register(
            type: (any PicsPersistenceServiceProtocol).self,
            allocation: .static
        ) { container in
            persistenceServiceFactory.makePicsPersistenceService(
                inMemory: false,
                authSessionService: container.resolve()
            )
        }

        container.register(
            type: (any PicsRepositoryProtocol).self,
            allocation: .dynamic
        ) { container in
            repositoryFactory.makePicsRepository(
                networkService: container.resolve(),
                persistenceService: container.resolve(),
                authSessionService: container.resolve(),
                sessionService: container.resolve()
            )
        }
    }
}
