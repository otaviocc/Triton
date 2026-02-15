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
import Foundation
import PURLsNetworkService
import PURLsPersistenceService
import SessionServiceInterface

/// A protocol for creating PURLs (Permanent URLs) repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// PURLs repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// PURLs repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for permanent URL management
/// operations. They handle PURL creation, redirection management, analytics tracking,
/// and provide seamless integration between remote API calls and local data storage
/// for URL metadata and usage statistics.
///
/// ## Usage Example
/// ```swift
/// let factory: PURLsRepositoryFactoryProtocol = PURLsRepositoryFactory()
/// let repository = factory.makePURLsRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol PURLsRepositoryFactoryProtocol {

    /// Creates a new PURLs repository instance.
    ///
    /// This method constructs a fully configured PURLs repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive permanent
    /// URL management capabilities including URL creation, analytics, and user
    /// context management.
    ///
    /// The created repository provides:
    /// - PURL creation and configuration with user ownership
    /// - URL redirection management and target updates
    /// - Analytics and usage statistics tracking
    /// - Real-time synchronization between local cache and remote data
    /// - User authentication state integration for access control
    /// - Session-aware PURL management and caching strategies
    /// - Offline PURL caching with intelligent sync capabilities
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote PURL operations.
    ///   - persistenceService: The persistence service for local data storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `PURLsRepositoryProtocol` instance ready for use.
    func makePURLsRepository(
        networkService: any PURLsNetworkServiceProtocol,
        persistenceService: any PURLsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PURLsRepositoryProtocol
}

public struct PURLsRepositoryFactory: PURLsRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePURLsRepository(
        networkService: any PURLsNetworkServiceProtocol,
        persistenceService: any PURLsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PURLsRepositoryProtocol {
        PURLsRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
