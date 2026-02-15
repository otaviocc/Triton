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

/// A protocol for creating authentication persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication persistence services with their required session service dependencies.
/// The factory pattern abstracts the complex initialization of persistence services
/// and enables dependency injection of different session service implementations.
///
/// Authentication persistence services handle secure storage and retrieval of OAuth
/// tokens and authentication state using the device's Keychain. Implementations
/// should configure the service with appropriate session services for state management.
///
/// ## Usage Example
/// ```swift
/// let factory: AuthPersistenceServiceFactoryProtocol = AuthPersistenceServiceFactory()
/// let service = factory.makeAuthPersistenceService(authSessionService: sessionService)
/// ```
public protocol AuthPersistenceServiceFactoryProtocol {

    /// Creates a new authentication persistence service instance.
    ///
    /// This method constructs a fully configured authentication persistence service
    /// with the provided session service. The persistence service handles secure
    /// storage of OAuth tokens and authentication state in the device's Keychain.
    ///
    /// The created service provides:
    /// - Secure token storage using Keychain Services
    /// - OAuth token lifecycle management (store, retrieve, remove)
    /// - Integration with session state management
    /// - Proper error handling for storage operations
    ///
    /// - Parameter authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `AuthPersistenceServiceProtocol` instance ready for use.
    func makeAuthPersistenceService(
        authSessionService: any AuthSessionServiceProtocol
    ) -> AuthPersistenceServiceProtocol
}

public struct AuthPersistenceServiceFactory: AuthPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthPersistenceService(
        authSessionService: any AuthSessionServiceProtocol
    ) -> AuthPersistenceServiceProtocol {
        AuthPersistenceService(
            authSessionService: authSessionService
        )
    }
}
