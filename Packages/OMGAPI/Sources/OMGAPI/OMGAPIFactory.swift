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

import Foundation
import MicroClient

/// A protocol for factories that create OMG API network clients.
///
/// This protocol defines the interface for creating configured network clients
/// that can communicate with the OMG.LOL API. It abstracts the client creation
/// process, allowing different implementations for testing, development, or
/// production environments.
///
/// The factory pattern is essential for dependency injection and provides a
/// clean separation between network client configuration and business logic.
/// It enables easy mocking for tests and centralized configuration management.
///
/// ## Usage Example
/// ```swift
/// let factory: OMGAPIFactoryProtocol = OMGAPIFactory()
/// let client = factory.makeOMGAPIClient { await authService.getToken() }
/// ```
public protocol OMGAPIFactoryProtocol {

    /// Creates a configured network client for the OMG.LOL API.
    ///
    /// This method constructs a network client with all necessary configuration
    /// for communicating with the OMG.LOL API, including base URL, authentication
    /// interceptors, and JSON encoding/decoding setup.
    ///
    /// The auth token provider is called for each authenticated request to retrieve
    /// the current access token. It should return `nil` if no token is available,
    /// allowing the client to handle unauthenticated requests appropriately.
    ///
    /// - Parameter authTokenProvider: An async closure that provides authentication tokens for API requests
    /// - Returns: A configured network client ready to make requests to the OMG.LOL API
    func makeOMGAPIClient(
        authTokenProvider: @escaping @Sendable () async -> String?
    ) -> NetworkClientProtocol
}

/// A concrete factory implementation for creating OMG API network clients.
///
/// `OMGAPIFactory` provides the default implementation for creating network clients
/// configured to communicate with the OMG.LOL API. It sets up all necessary
/// components including authentication interceptors, JSON codecs, base URL
/// configuration, and logging.
///
/// The factory creates clients with the following configuration:
/// - **Base URL**: `https://api.omg.lol`
/// - **Authentication**: Bearer token authentication via interceptor
/// - **Encoding/Decoding**: JSON with default settings
/// - **Logging**: stdout logging at warning level
/// - **Session**: Shared URLSession for HTTP requests
///
/// ## Usage Example
/// ```swift
/// let factory = OMGAPIFactory()
/// let client = factory.makeOMGAPIClient {
///     await authenticationService.getAccessToken()
/// }
///
/// // Use client with request factories
/// let request = AccountRequestFactory.makeAccountInformationRequest()
/// let response = try await client.run(request)
/// ```
///
/// ## Integration
/// This factory integrates with the broader application architecture by:
/// - Providing configured clients to service layers
/// - Supporting dependency injection patterns
/// - Enabling easy testing with mockable protocols
public struct OMGAPIFactory: OMGAPIFactoryProtocol {

    // MARK: - Lifecycle

    /// Creates a new OMG API factory.
    ///
    /// This initializer creates a factory instance ready to produce configured
    /// network clients for the OMG.LOL API. No configuration is required as
    /// the factory uses standard API settings.
    public init() {}

    // MARK: - Public

    /// Creates a configured network client for the OMG.LOL API.
    ///
    /// This method assembles all necessary components to create a fully configured
    /// network client. It sets up authentication interceptors using the provided
    /// token provider, configures the base URL and JSON codecs, and creates a
    /// client ready for API communication.
    ///
    /// The created client includes:
    /// - Bearer token authentication interceptor
    /// - JSON encoding and decoding capabilities
    /// - Proper base URL configuration for the OMG.LOL API
    /// - Request/response logging at warning level
    ///
    /// - Parameter authTokenProvider: An async closure that provides authentication tokens
    /// - Returns: A configured NetworkClient instance ready for API requests
    public func makeOMGAPIClient(
        authTokenProvider: @escaping @Sendable () async -> String?
    ) -> NetworkClientProtocol {
        let interceptors = makeAPIInterceptors(
            authTokenProvider: authTokenProvider
        )

        let configuration = makeAPIConfiguration(
            interceptors: interceptors
        )

        return NetworkClient(
            configuration: configuration
        )
    }
}

// MARK: - Private

private func makeAPIInterceptors(
    authTokenProvider: @escaping @Sendable () async -> String?
) -> [NetworkRequestInterceptor] {
    [
        BearerAuthorizationInterceptor(
            tokenProvider: authTokenProvider
        )
    ]
}

private func makeAPIConfiguration(
    interceptors: [NetworkRequestInterceptor]
) -> NetworkConfiguration {
    .init(
        session: URLSession.shared,
        defaultDecoder: JSONDecoder(),
        defaultEncoder: JSONEncoder(),
        baseURL: URL(string: "https://api.omg.lol")!,
        logger: StdoutLogger(),
        logLevel: .warning,
        interceptors: interceptors
    )
}
