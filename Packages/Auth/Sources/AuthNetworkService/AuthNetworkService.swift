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
import OMGAPI

/// A protocol for network operations related to authentication token exchange.
///
/// This protocol defines the interface for handling OAuth-style authentication flows,
/// specifically the exchange of authorization codes for access tokens. It manages the
/// network communication with the authentication server to complete the OAuth flow
/// after the user has been redirected back to the application with an authorization code.
///
/// The protocol handles the critical step in OAuth flows where a temporary authorization
/// code (typically received via URL callback or deep link) is exchanged for a persistent
/// access token that can be used for authenticated API requests.
public protocol AuthNetworkServiceProtocol: AnyObject, Sendable {

    /// Exchanges an authorization code for an access token.
    ///
    /// This method implements the OAuth "authorization code" flow by sending the
    /// authorization code to the authentication server and receiving an access token
    /// in response. The authorization code is typically obtained when the user
    /// completes the authentication process and is redirected back to the application.
    ///
    /// The access token returned by this method can be used for subsequent authenticated
    /// API requests and should be securely stored for future use.
    ///
    /// This is a critical security operation that must be performed over HTTPS to
    /// protect the authorization code and access token during transmission.
    ///
    /// - Parameter code: The authorization code received from the OAuth callback/redirect.
    /// - Returns: The access token that can be used for authenticated requests.
    /// - Throws: Network errors, authentication errors, or API validation errors if the code exchange fails.
    func accessToken(
        code: String
    ) async throws -> String
}

actor AuthNetworkService: AuthNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol
    private let requestFactory: AuthRequestFactory

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol,
        requestFactory: AuthRequestFactory
    ) {
        self.networkClient = networkClient
        self.requestFactory = requestFactory
    }

    // MARK: - Public

    func accessToken(
        code: String
    ) async throws -> String {
        let request = requestFactory.makeAuthRequest(
            code: code
        )

        let response = try await networkClient.run(request)

        return response.value.accessToken
    }
}
