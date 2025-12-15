import AuthSessionServiceInterface
import ClipboardService
import Foundation
import MicroClient
import MicroContainer
import PURLsNetworkService
import PURLsPersistenceService
import PURLsRepository
import SessionServiceInterface
import SwiftData

struct PURLsEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as any PURLsRepositoryProtocol)
            .purlsContainer
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
            networkServiceFactory: PURLsNetworkServiceFactory(),
            persistenceServiceFactory: PURLsPersistenceServiceFactory(),
            repositoryFactory: PURLsRepositoryFactory(),
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService,
            clipboardService: clipboardService
        )
    }

    init(
        networkServiceFactory: PURLsNetworkServiceFactoryProtocol,
        persistenceServiceFactory: PURLsPersistenceServiceFactoryProtocol,
        repositoryFactory: PURLsRepositoryFactoryProtocol,
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
            type: (any PURLsNetworkServiceProtocol).self,
            allocation: .dynamic
        ) { container in
            networkServiceFactory
                .makePURLsNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: PURLsPersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makePURLsPersistenceService(
                    inMemory: false,
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: (any PURLsRepositoryProtocol).self,
            allocation: .dynamic
        ) { container in
            repositoryFactory
                .makePURLsRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve(),
                    authSessionService: container.resolve(),
                    sessionService: container.resolve()
                )
        }
    }
}
