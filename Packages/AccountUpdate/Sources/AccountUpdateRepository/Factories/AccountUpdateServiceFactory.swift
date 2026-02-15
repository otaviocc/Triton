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
import AuthSessionServiceInterface

/// A protocol for creating account update repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// account update repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Account update repositories coordinate between network, persistence, and authentication
/// layers to provide a unified interface for account management operations. They handle
/// account profile updates, settings modifications, data synchronization, and provide
/// seamless integration between remote API calls and local data storage for account
/// information and user preferences.
///
/// ## Usage Example
/// ```swift
/// let factory: AccountUpdateRepositoryFactoryProtocol = AccountUpdateRepositoryFactory()
/// let repository = factory.makeAccountUpdateRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService
/// )
/// ```
public protocol AccountUpdateRepositoryFactoryProtocol {

    /// Creates a new account update repository instance.
    ///
    /// This method constructs a fully configured account update repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// and authentication services to provide comprehensive account management
    /// capabilities including profile updates, settings synchronization, and user
    /// context management.
    ///
    /// The created repository provides:
    /// - Account profile updates with optimistic UI updates and rollback support
    /// - Settings synchronization between local preferences and remote storage
    /// - Draft management for multi-step account modification workflows
    /// - Real-time synchronization between local cache and remote account data
    /// - User authentication state integration for secure operations
    /// - Conflict resolution for concurrent account modifications
    /// - Timer-based periodic synchronization for account data freshness
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote account update operations.
    ///   - persistenceService: The persistence service for local data storage and caching.
    ///   - authSessionService: The authentication session service for user context.
    /// - Returns: A configured `AccountUpdateRepositoryProtocol` instance ready for use.
    func makeAccountUpdateRepository(
        networkService: AccountUpdateNetworkServiceProtocol,
        persistenceService: AccountUpdatePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) -> AccountUpdateRepositoryProtocol
}

public final class AccountUpdateRepositoryFactory: AccountUpdateRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAccountUpdateRepository(
        networkService: AccountUpdateNetworkServiceProtocol,
        persistenceService: AccountUpdatePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) -> AccountUpdateRepositoryProtocol {
        AccountUpdateRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService
        )
    }
}
