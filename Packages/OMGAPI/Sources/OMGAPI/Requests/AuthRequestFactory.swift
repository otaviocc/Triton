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

/// A factory for creating authentication-related API requests and URLs.
///
/// `AuthRequestFactory` provides methods for OAuth 2.0 authentication
/// with the OMG.LOL API. It handles both the initial OAuth authorization URL
/// generation and the subsequent token exchange request creation.
///
/// Credentials are supplied at initialisation via `OAuthClientConfiguration`
/// and are typically sourced from the app's build settings (xcconfig) rather
/// than being hardcoded.
public struct AuthRequestFactory: Sendable {

    // MARK: - Properties

    private let configuration: OAuthClientConfiguration

    // MARK: - Lifecycle

    public init(configuration: OAuthClientConfiguration) {
        self.configuration = configuration
    }

    // MARK: - Public

    /// Creates the OAuth authorization URL to start the authentication process.
    ///
    /// - Returns: The OAuth authorization URL, or `nil` if URL construction fails.
    public func makeOAuthCodeRequestURL() -> URL? {
        let url = URL(string: "https://home.omg.lol/oauth/authorize")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        components?.queryItems = [
            .init(name: "client_id", value: configuration.id),
            .init(name: "scope", value: "everything"),
            .init(name: "redirect_uri", value: configuration.redirectURI),
            .init(name: "response_type", value: "code")
        ]

        return components?.url
    }

    /// Creates a request to exchange an OAuth authorization code for an access token.
    ///
    /// - Parameter code: The authorization code received from the OAuth callback.
    /// - Returns: A configured network request for exchanging the code for an access token.
    public func makeAuthRequest(
        code: String
    ) -> NetworkRequest<VoidRequest, AccessTokenResponse> {
        .init(
            path: "/oauth",
            method: .get,
            queryItems: [
                .init(name: "client_id", value: configuration.id),
                .init(name: "client_secret", value: configuration.secret),
                .init(name: "redirect_uri", value: configuration.redirectURI),
                .init(name: "code", value: code),
                .init(name: "scope", value: "everything")
            ]
        )
    }
}
