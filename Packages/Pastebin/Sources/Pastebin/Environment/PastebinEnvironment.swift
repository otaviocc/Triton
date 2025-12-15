import AuthSessionServiceInterface
import ClipboardService
import Foundation
import MicroClient
import MicroContainer
import PastebinNetworkService
import PastebinPersistenceService
import PastebinRepository
import SessionServiceInterface
import SwiftData

struct PastebinEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as any PastebinRepositoryProtocol)
            .pastebinContainer
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
            networkServiceFactory: PastebinNetworkServiceFactory(),
            persistenceServiceFactory: PastebinPersistenceServiceFactory(),
            repositoryFactory: PastebinRepositoryFactory(),
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService,
            clipboardService: clipboardService
        )
    }

    init(
        networkServiceFactory: PastebinNetworkServiceFactoryProtocol,
        persistenceServiceFactory: PastebinPersistenceServiceFactoryProtocol,
        repositoryFactory: PastebinRepositoryFactoryProtocol,
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
            type: (any PastebinNetworkServiceProtocol).self,
            allocation: .dynamic
        ) { container in
            networkServiceFactory
                .makePastebinNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: PastebinPersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makePastebinPersistenceService(
                    inMemory: false,
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: (any PastebinRepositoryProtocol).self,
            allocation: .dynamic
        ) { container in
            repositoryFactory
                .makePastebinRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve(),
                    authSessionService: container.resolve(),
                    sessionService: container.resolve()
                )
        }
    }
}
