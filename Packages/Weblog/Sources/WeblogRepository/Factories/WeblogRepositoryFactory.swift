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
import SessionServiceInterface
import WeblogNetworkService
import WeblogPersistenceService

/// A protocol for creating weblog repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// weblog repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Weblog repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for blog management operations.
/// They handle blog entry creation, editing, publishing workflows, and provide
/// seamless integration between remote API calls and local data storage for blog
/// content, metadata, categories, and user-specific blog collections.
///
/// ## Usage Example
/// ```swift
/// let factory: WeblogRepositoryFactoryProtocol = WeblogRepositoryFactory()
/// let repository = factory.makeWeblogRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol WeblogRepositoryFactoryProtocol {

    /// Creates a new weblog repository instance.
    ///
    /// This method constructs a fully configured weblog repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive blog
    /// management capabilities including content creation, publishing workflows,
    /// and user context management.
    ///
    /// The created repository provides:
    /// - Blog entry creation and publishing with rich content editing support
    /// - Entry retrieval with personalization and category filtering
    /// - Content editing and revision management capabilities
    /// - Draft management for multi-step blog creation workflows
    /// - Real-time synchronization between local drafts and remote storage
    /// - User authentication state integration for private blog management
    /// - Session-aware blog collections and publication history
    /// - Category and tag management for content organization
    /// - RSS feed generation and syndication support
    /// - Publishing workflow management with scheduling capabilities
    /// - Comment and engagement tracking integration
    /// - Offline editing support with intelligent sync capabilities
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote weblog operations.
    ///   - persistenceService: The persistence service for local blog storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `WeblogRepositoryProtocol` instance ready for use.
    func makeWeblogRepository(
        networkService: any WeblogNetworkServiceProtocol,
        persistenceService: any WeblogPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any WeblogRepositoryProtocol
}

public struct WeblogRepositoryFactory: WeblogRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWeblogRepository(
        networkService: any WeblogNetworkServiceProtocol,
        persistenceService: any WeblogPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any WeblogRepositoryProtocol {
        WeblogRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
