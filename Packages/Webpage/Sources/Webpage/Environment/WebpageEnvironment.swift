import AuthSessionServiceInterface
import Foundation
import MicroClient
import MicroContainer
import SessionServiceInterface
import SwiftData
import WebpageNetworkService
import WebpagePersistenceService
import WebpageRepository

struct WebpageEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as any WebpageRepositoryProtocol)
            .webpageContainer
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.init(
            networkServiceFactory: WebpageNetworkServiceFactory(),
            persistenceServiceFactory: WebpagePersistenceServiceFactory(),
            repositoryFactory: WebpageRepositoryFactory(),
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }

    init(
        networkServiceFactory: WebpageNetworkServiceFactoryProtocol,
        persistenceServiceFactory: WebpagePersistenceServiceFactoryProtocol,
        repositoryFactory: WebpageRepositoryFactoryProtocol,
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
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
            type: ViewModelFactory.self,
            allocation: .static
        ) { container in
            ViewModelFactory(
                container: container
            )
        }

        container.register(
            type: (any WebpageNetworkServiceProtocol).self,
            allocation: .dynamic
        ) { container in
            networkServiceFactory
                .makeWebpageNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: WebpagePersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makeWebpagePersistenceService(
                    inMemory: false,
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: (any WebpageRepositoryProtocol).self,
            allocation: .dynamic
        ) { container in
            repositoryFactory
                .makeWebpageRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve(),
                    authSessionService: container.resolve(),
                    sessionService: container.resolve()
                )
        }
    }
}
