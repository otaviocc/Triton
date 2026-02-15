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
import NowNetworkService
import NowPersistenceService
import SessionServiceInterface

/// A protocol for creating "Now" page repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// "Now" page repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Now page repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for "Now" page management
/// operations. They handle current activity updates, user context management,
/// data synchronization, and provide seamless integration between remote API
/// calls and local data storage.
///
/// ## Usage Example
/// ```swift
/// let factory: NowRepositoryFactoryProtocol = NowRepositoryFactory()
/// let repository = factory.makeNowRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol NowRepositoryFactoryProtocol {

    /// Creates a new "Now" page repository instance.
    ///
    /// This method constructs a fully configured "Now" page repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive "Now" page
    /// management capabilities including user context management and data synchronization.
    ///
    /// The created repository provides:
    /// - Current activity creation and updates with user context
    /// - "Now" page content retrieval with personalization
    /// - Real-time activity synchronization between local and remote
    /// - User authentication state integration
    /// - Session-aware data management and caching
    /// - Offline support with intelligent sync strategies
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote "Now" page operations.
    ///   - persistenceService: The persistence service for local data storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `NowRepositoryProtocol` instance ready for use.
    func makeNowRepository(
        networkService: NowNetworkServiceProtocol,
        persistenceService: NowPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any NowRepositoryProtocol
}

public struct NowRepositoryFactory: NowRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeNowRepository(
        networkService: NowNetworkServiceProtocol,
        persistenceService: NowPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any NowRepositoryProtocol {
        NowRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
