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

import MicroClient

/// A protocol for creating authentication network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Authentication network services handle OAuth-related HTTP requests including
/// authorization code exchange for access tokens. Implementations should configure
/// the service with appropriate network clients for API communication.
///
/// ## Usage Example
/// ```swift
/// let factory: AuthNetworkServiceFactoryProtocol = AuthNetworkServiceFactory()
/// let service = factory.makeAuthNetworkService(networkClient: networkClient)
/// ```
public protocol AuthNetworkServiceFactoryProtocol {

    /// Creates a new authentication network service instance.
    ///
    /// This method constructs a fully configured authentication network service
    /// with the provided HTTP client. The service handles OAuth token exchange
    /// requests and other authentication-related network operations.
    ///
    /// The created service provides:
    /// - OAuth authorization code to access token exchange
    /// - HTTP client abstraction for network operations
    /// - Proper error handling for authentication failures
    /// - Integration with the broader authentication system
    ///
    /// - Parameter networkClient: The network client for performing HTTP requests.
    /// - Returns: A configured `AuthNetworkServiceProtocol` instance ready for use.
    func makeAuthNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AuthNetworkServiceProtocol
}

public struct AuthNetworkServiceFactory: AuthNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AuthNetworkServiceProtocol {
        AuthNetworkService(
            networkClient: networkClient
        )
    }
}
