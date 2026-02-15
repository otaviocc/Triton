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

/// A protocol for creating authentication session service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication session services with secure Keychain storage. The factory pattern
/// abstracts the complex initialization of the authentication service and its dependencies,
/// providing a clean interface for dependency injection and testing.
///
/// Implementations should configure the service with appropriate secure storage
/// mechanisms and any required dependencies for authentication state management.
public protocol AuthSessionServiceFactoryProtocol {

    /// Creates a new authentication session service instance.
    ///
    /// This method constructs a fully configured authentication session service
    /// with secure Keychain storage for access tokens. The service is initialized
    /// with any existing tokens from secure storage and is ready for immediate use.
    ///
    /// The created service handles:
    /// - Secure token storage and retrieval via Keychain
    /// - Authentication state management
    /// - Reactive streams for login state and logout events
    /// - Automatic token persistence across app launches
    ///
    /// - Returns: A configured `AuthSessionServiceProtocol` instance ready for use.
    func makeAuthSessionService() -> any AuthSessionServiceProtocol
}

public struct AuthSessionServiceFactory: AuthSessionServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthSessionService() -> any AuthSessionServiceProtocol {
        let store = KeychainStore(
            "Triton: Access Token"
        )

        return AuthSessionService(
            keychainStore: store
        )
    }
}
