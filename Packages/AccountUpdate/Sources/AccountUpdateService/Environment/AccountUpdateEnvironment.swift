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
