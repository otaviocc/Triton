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

import AuthNetworkService
import AuthPersistenceService
import AuthRepository
import AuthSessionServiceInterface
import MicroClient
import MicroContainer
import OMGAPI

struct AuthEnvironment {

    // MARK: - Properties

    var viewModelFactory: ViewModelFactory {
        container.resolve()
    }

    private let container = DependencyContainer()

    // MARK: - Lifecycle

    init(
        oauthConfiguration: OAuthClientConfiguration,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        self.init(
            oauthConfiguration: oauthConfiguration,
            repositoryFactory: AuthRepositoryFactory(),
            networkServiceFactory: AuthNetworkServiceFactory(),
            persistenceServiceFactory: AuthPersistenceServiceFactory(),
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    // swiftlint:disable function_body_length
    init(
        oauthConfiguration: OAuthClientConfiguration,
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

        let requestFactory = AuthRequestFactory(configuration: oauthConfiguration)

        container.register(
            type: AuthRequestFactory.self,
            allocation: .static
        ) { _ in
            requestFactory
        }

        container.register(
            type: AuthNetworkServiceProtocol.self,
            allocation: .static
        ) { container in
            networkServiceFactory
                .makeAuthNetworkService(
                    networkClient: container.resolve(),
                    requestFactory: container.resolve()
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
    // swiftlint:enable function_body_length
}
