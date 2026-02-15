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

/// A factory protocol for creating pictures network service instances.
///
/// This protocol defines the interface for creating `PicsNetworkService` instances
/// with the required network client dependency. The factory pattern allows for
/// flexible dependency injection and testing by abstracting the creation process.
///
/// Implementations of this protocol are responsible for configuring the network
/// service with the appropriate network client for communicating with the OMG.LOL
/// pictures API endpoints.
public protocol PicsNetworkServiceFactoryProtocol {

    /// Creates a new pictures network service instance.
    ///
    /// This method creates and configures a `PicsNetworkService` with the provided
    /// network client. The network client handles the actual HTTP communication
    /// with the OMG.LOL API endpoints.
    ///
    /// The created service will be ready to perform pictures-related network
    /// operations such as fetching user pictures and uploading new pictures.
    ///
    /// - Parameter networkClient: The network client to use for API communication
    /// - Returns: A configured pictures network service instance
    func makePicsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PicsNetworkServiceProtocol
}

public struct PicsNetworkServiceFactory: PicsNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePicsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PicsNetworkServiceProtocol {
        PicsNetworkService(
            networkClient: networkClient
        )
    }
}
