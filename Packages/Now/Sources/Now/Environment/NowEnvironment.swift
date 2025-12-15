import AuthSessionServiceInterface
import Foundation
import FoundationExtensions
import MicroClient
import MicroContainer
import NowNetworkService
import NowPersistenceService
import NowRepository
import SessionServiceInterface
import SwiftData

struct NowEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    var modelContainer: ModelContainer {
        (container.resolve() as any NowRepositoryProtocol)
            .nowContainer
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.init(
            networkServiceFactory: NowNetworkServiceFactory(),
            persistenceServiceFactory: NowPersistenceServiceFactory(),
            repositoryFactory: NowRepositoryFactory(),
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }

    init(
        networkServiceFactory: NowNetworkServiceFactoryProtocol,
        persistenceServiceFactory: NowPersistenceServiceFactoryProtocol,
        repositoryFactory: NowRepositoryFactoryProtocol,
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
            type: NowNetworkServiceProtocol.self,
            allocation: .dynamic
        ) { container in
            networkServiceFactory
                .makeNowNetworkService(
                    networkClient: container.resolve()
                )
        }

        container.register(
            type: NowPersistenceServiceProtocol.self,
            allocation: .static
        ) { container in
            persistenceServiceFactory
                .makeNowPersistenceService(
                    inMemory: false,
                    authSessionService: container.resolve()
                )
        }

        container.register(
            type: (any NowRepositoryProtocol).self,
            allocation: .dynamic
        ) { container in
            repositoryFactory
                .makeNowRepository(
                    networkService: container.resolve(),
                    persistenceService: container.resolve(),
                    authSessionService: container.resolve(),
                    sessionService: container.resolve()
                )
        }
    }
}
