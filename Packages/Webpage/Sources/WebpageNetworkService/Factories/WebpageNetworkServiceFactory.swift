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

/// A protocol for creating webpage network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// webpage network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Webpage network services handle HTTP requests for web content operations
/// including creating, updating, retrieving, and deleting web pages and their
/// associated content. They also manage publishing workflows, content versioning,
/// and metadata synchronization. Implementations should configure the service
/// with appropriate network clients for API communication with content management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: WebpageNetworkServiceFactoryProtocol = WebpageNetworkServiceFactory()
/// let service = factory.makeWebpageNetworkService(networkClient: networkClient)
/// ```
public protocol WebpageNetworkServiceFactoryProtocol {

    /// Creates a new webpage network service instance.
    ///
    /// This method constructs a fully configured webpage network service with the
    /// provided HTTP client. The service handles web content-related network
    /// operations including CRUD operations for web pages, content publishing,
    /// and metadata management.
    ///
    /// The created service provides:
    /// - Webpage creation and publishing with content validation
    /// - Content retrieval and synchronization with remote endpoints
    /// - Webpage update and editing capabilities with version control
    /// - Draft management and publishing workflow support
    /// - Media upload and asset management for web content
    /// - SEO metadata and content optimization features
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `WebpageNetworkServiceProtocol` instance ready for use.
    func makeWebpageNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WebpageNetworkServiceProtocol
}

public struct WebpageNetworkServiceFactory: WebpageNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWebpageNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WebpageNetworkServiceProtocol {
        WebpageNetworkService(
            networkClient: networkClient
        )
    }
}
