// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

    // swiftlint:disable function_body_length
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
    // swiftlint:enable function_body_length
}
