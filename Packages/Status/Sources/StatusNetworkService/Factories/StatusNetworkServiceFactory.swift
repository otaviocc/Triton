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

/// A protocol for creating status network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// status network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Status network services handle HTTP requests for status-related operations
/// including creating, updating, retrieving, and deleting user status updates.
/// Implementations should configure the service with appropriate network clients
/// for API communication with status endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: StatusNetworkServiceFactoryProtocol = StatusNetworkServiceFactory()
/// let service = factory.makeStatusNetworkService(networkClient: networkClient)
/// ```
public protocol StatusNetworkServiceFactoryProtocol {

    /// Creates a new status network service instance.
    ///
    /// This method constructs a fully configured status network service with the
    /// provided HTTP client. The service handles status-related network operations
    /// including CRUD operations for user status updates.
    ///
    /// The created service provides:
    /// - Status creation and publishing to remote endpoints
    /// - Status retrieval and timeline synchronization
    /// - Status update and editing capabilities
    /// - Status deletion and cleanup operations
    /// - Proper error handling for network failures
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `StatusNetworkServiceProtocol` instance ready for use.
    func makeStatusNetworkService(
        networkClient: NetworkClientProtocol
    ) -> StatusNetworkServiceProtocol
}

public struct StatusNetworkServiceFactory: StatusNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeStatusNetworkService(
        networkClient: NetworkClientProtocol
    ) -> StatusNetworkServiceProtocol {
        StatusNetworkService(
            networkClient: networkClient
        )
    }
}
