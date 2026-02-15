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

/// A protocol for creating authentication repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication repositories with their required dependencies. The factory pattern
/// abstracts the complex initialization of authentication repositories and their
/// network and persistence service dependencies.
///
/// Implementations should configure the repository with appropriate network services
/// for OAuth token exchange and persistence services for secure token storage.
public protocol AuthRepositoryFactoryProtocol {

    /// Creates a new authentication repository instance.
    ///
    /// This method constructs a fully configured authentication repository with
    /// the provided network and persistence services. The repository coordinates
    /// between these services to provide complete OAuth authentication flow
    /// management and secure token storage.
    ///
    /// The created repository handles:
    /// - OAuth authorization code exchange via the network service
    /// - Secure token storage and retrieval via the persistence service
    /// - Deep link URL parsing for authentication callbacks
    /// - Token lifecycle management (store, retrieve, remove)
    ///
    /// - Parameters:
    ///   - networkService: The network service for OAuth token exchange operations.
    ///   - persistenceService: The persistence service for secure token storage.
    /// - Returns: A configured `AuthRepositoryProtocol` instance ready for use.
    func makeAuthRepository(
        networkService: AuthNetworkServiceProtocol,
        persistenceService: AuthPersistenceServiceProtocol
    ) -> AuthRepositoryProtocol
}

public struct AuthRepositoryFactory: AuthRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthRepository(
        networkService: AuthNetworkServiceProtocol,
        persistenceService: AuthPersistenceServiceProtocol
    ) -> AuthRepositoryProtocol {
        AuthRepository(
            networkService: networkService,
            persistenceService: persistenceService
        )
    }
}
