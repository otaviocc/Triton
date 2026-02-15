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

/// A protocol for creating account update persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// account update persistence services with their required session service dependencies.
/// The factory pattern abstracts the complex initialization of persistence services
/// and enables dependency injection of different session service implementations.
///
/// Account update persistence services handle local storage and caching of account
/// update operations, temporary data management during account modification workflows,
/// and integration with session state for user context. Implementations should configure
/// the service with appropriate session services for state management and user context.
///
/// ## Usage Example
/// ```swift
/// let factory: AccountUpdatePersistenceServiceFactoryProtocol = AccountUpdatePersistenceServiceFactory()
/// let service = factory.makeAccountUpdatePersistenceService(
///     sessionService: sessionService,
///     authSessionService: authSessionService
/// )
/// ```
public protocol AccountUpdatePersistenceServiceFactoryProtocol {

    /// Creates a new account update persistence service instance.
    ///
    /// This method constructs a fully configured account update persistence service
    /// with the provided session services. The persistence service handles local
    /// storage of account update operations, draft management, and integration with
    /// user session state for context-aware account modifications.
    ///
    /// The created service provides:
    /// - Local storage of account update drafts and pending changes
    /// - Session-aware account modification workflows
    /// - Integration with user authentication state for secure operations
    /// - Temporary data management during multi-step account updates
    /// - Cache management for account-related data and preferences
    ///
    /// - Parameters:
    ///   - sessionService: The session service for user state management.
    ///   - authSessionService: The authentication session service for user context.
    /// - Returns: A configured `AccountUpdatePersistenceServiceProtocol` instance ready for use.
    func makeAccountUpdatePersistenceService(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) -> AccountUpdatePersistenceServiceProtocol
}

public final class AccountUpdatePersistenceServiceFactory: AccountUpdatePersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAccountUpdatePersistenceService(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) -> AccountUpdatePersistenceServiceProtocol {
        AccountUpdatePersistenceService(
            sessionService: sessionService,
            authSessionService: authSessionService
        )
    }
}
