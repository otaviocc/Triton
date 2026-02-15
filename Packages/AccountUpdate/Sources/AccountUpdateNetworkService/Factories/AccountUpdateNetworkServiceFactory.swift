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

/// A protocol for creating account update network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// account update network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Account update network services handle HTTP requests for account-related operations
/// including profile updates, settings modifications, and account information retrieval.
/// Implementations should configure the service with appropriate network clients
/// for API communication with account management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: AccountUpdateNetworkServiceFactoryProtocol = AccountUpdateNetworkServiceFactory()
/// let service = factory.makeAccountUpdateNetworkService(networkClient: networkClient)
/// ```
public protocol AccountUpdateNetworkServiceFactoryProtocol {

    /// Creates a new account update network service instance.
    ///
    /// This method constructs a fully configured account update network service with
    /// the provided HTTP client. The service handles account-related network operations
    /// including profile updates, settings changes, and account information synchronization.
    ///
    /// The created service provides:
    /// - Account profile update operations via HTTP APIs
    /// - Account settings modification and retrieval
    /// - User preference synchronization with remote endpoints
    /// - Account information validation and submission
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `AccountUpdateNetworkServiceProtocol` instance ready for use.
    func makeAccountUpdateNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AccountUpdateNetworkServiceProtocol
}

public struct AccountUpdateNetworkServiceFactory: AccountUpdateNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAccountUpdateNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AccountUpdateNetworkServiceProtocol {
        AccountUpdateNetworkService(
            networkClient: networkClient
        )
    }
}
