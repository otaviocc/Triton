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

/// A protocol for creating PURLs network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// PURLs (Permanent URLs) network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// PURLs network services handle HTTP requests for permanent URL operations
/// including creating, updating, retrieving, and deleting custom URL redirections.
/// They also manage analytics data and redirection statistics. Implementations
/// should configure the service with appropriate network clients for API
/// communication with PURL management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: PURLsNetworkServiceFactoryProtocol = PURLsNetworkServiceFactory()
/// let service = factory.makePURLsNetworkService(networkClient: networkClient)
/// ```
public protocol PURLsNetworkServiceFactoryProtocol {

    /// Creates a new PURLs network service instance.
    ///
    /// This method constructs a fully configured PURLs network service with the
    /// provided HTTP client. The service handles permanent URL-related network
    /// operations including CRUD operations for custom redirections, analytics
    /// tracking, and redirection management.
    ///
    /// The created service provides:
    /// - PURL creation and configuration with custom paths and targets
    /// - URL redirection management and target updates
    /// - Analytics retrieval and statistics tracking
    /// - PURL deletion and cleanup operations
    /// - Bulk operations for managing multiple PURLs
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `PURLsNetworkServiceProtocol` instance ready for use.
    func makePURLsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PURLsNetworkServiceProtocol
}

public struct PURLsNetworkServiceFactory: PURLsNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePURLsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PURLsNetworkServiceProtocol {
        PURLsNetworkService(
            networkClient: networkClient
        )
    }
}
