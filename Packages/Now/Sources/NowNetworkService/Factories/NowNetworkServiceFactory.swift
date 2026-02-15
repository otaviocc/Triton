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

/// A protocol for creating "Now" page network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// "Now" page network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Now page network services handle HTTP requests for "Now" page operations
/// including creating, updating, and retrieving user's current status or activity.
/// Implementations should configure the service with appropriate network clients
/// for API communication with "Now" page endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: NowNetworkServiceFactoryProtocol = NowNetworkServiceFactory()
/// let service = factory.makeNowNetworkService(networkClient: networkClient)
/// ```
public protocol NowNetworkServiceFactoryProtocol {

    /// Creates a new "Now" page network service instance.
    ///
    /// This method constructs a fully configured "Now" page network service with
    /// the provided HTTP client. The service handles "Now" page related network
    /// operations including updating and retrieving the user's current activity.
    ///
    /// The created service provides:
    /// - "Now" page content creation and updates
    /// - Current activity retrieval from remote endpoints
    /// - Real-time status synchronization
    /// - Proper error handling for network failures
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `NowNetworkServiceProtocol` instance ready for use.
    func makeNowNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any NowNetworkServiceProtocol
}

public struct NowNetworkServiceFactory: NowNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeNowNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any NowNetworkServiceProtocol {
        NowNetworkService(
            networkClient: networkClient
        )
    }
}
