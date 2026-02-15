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

/// A protocol for creating weblog network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// weblog network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Weblog network services handle HTTP requests for blog-related operations
/// including creating, updating, retrieving, and deleting blog entries and posts.
/// They also manage blog metadata, categories, tags, and publishing workflows.
/// Implementations should configure the service with appropriate network clients
/// for API communication with blog management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: WeblogNetworkServiceFactoryProtocol = WeblogNetworkServiceFactory()
/// let service = factory.makeWeblogNetworkService(networkClient: networkClient)
/// ```
public protocol WeblogNetworkServiceFactoryProtocol {

    /// Creates a new weblog network service instance.
    ///
    /// This method constructs a fully configured weblog network service with the
    /// provided HTTP client. The service handles blog-related network operations
    /// including CRUD operations for blog entries, publishing workflows, and
    /// metadata management.
    ///
    /// The created service provides:
    /// - Blog entry creation and publishing with content validation
    /// - Entry retrieval and timeline synchronization
    /// - Blog post update and editing capabilities with revision history
    /// - Draft management and publishing workflow support
    /// - Category and tag management for content organization
    /// - Blog metadata and configuration synchronization
    /// - RSS feed generation and syndication support
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `WeblogNetworkServiceProtocol` instance ready for use.
    func makeWeblogNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WeblogNetworkServiceProtocol
}

public struct WeblogNetworkServiceFactory: WeblogNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWeblogNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WeblogNetworkServiceProtocol {
        WeblogNetworkService(
            networkClient: networkClient
        )
    }
}
