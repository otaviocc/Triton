import Foundation
import MicroClient

/// A factory for creating authentication-related API requests and URLs.
///
/// `AuthRequestFactory` provides static methods for OAuth 2.0 authentication
/// with the OMG.LOL API. It handles both the initial OAuth authorization URL
/// generation and the subsequent token exchange request creation.
///
/// The factory encapsulates OAuth client configuration including client ID,
/// client secret, redirect URI, and API scopes. It follows the OAuth 2.0
/// authorization code flow pattern for secure authentication.
///
/// ## Usage Example
/// ```swift
/// // Start OAuth flow
/// if let authURL = AuthRequestFactory.makeOAuthCodeRequestURL() {
///     // Open URL in browser or web view
///     NSWorkspace.shared.open(authURL)
/// }
///
/// // After receiving authorization code from redirect
/// let tokenRequest = AuthRequestFactory.makeAuthRequest(code: authCode)
/// let tokenResponse = try await networkClient.run(tokenRequest)
/// let accessToken = tokenResponse.response.accessToken
/// ```
///
/// ## OAuth Configuration
/// The factory uses predefined OAuth client credentials and configuration:
/// - **Scope**: "everything" - Full access to user's account
/// - **Response Type**: "code" - Authorization code flow
/// - **Redirect URI**: Custom app scheme for handling OAuth callbacks
///
/// ## Security Note
/// Client credentials are embedded for the official OMG.LOL application.
/// The client secret is used only for server-side token exchange and is
/// necessary for the OAuth 2.0 flow implementation.
public enum AuthRequestFactory {

    // MARK: - Nested types

    /// Constants used for OAuth authentication configuration.
    private enum Constant {

        /// OAuth client configuration for the OMG.LOL application.
        enum Client {

            /// The OAuth client identifier registered with OMG.LOL.
            static let id = ""

            /// The OAuth client secret for token exchange requests.
            static let secret = ""

            /// The registered redirect URI for handling OAuth callbacks.
            static let redirectURI = ""

            /// The OAuth scope requested for full account access.
            static let scope = "everything"
        }
    }

    // MARK: - Public

    /// Creates the OAuth authorization URL to start the authentication process.
    ///
    /// This method builds a properly formatted OAuth 2.0 authorization URL that
    /// should be opened in a browser or web view to initiate user authentication.
    /// The URL includes all necessary query parameters for the OAuth flow.
    ///
    /// The authorization process works as follows:
    /// 1. User is redirected to the returned URL
    /// 2. User authenticates with OMG.LOL and grants permissions
    /// 3. OMG.LOL redirects back to the app with an authorization code
    /// 4. The authorization code is exchanged for an access token
    ///
    /// Query parameters included:
    /// - `client_id`: The registered OAuth client identifier
    /// - `scope`: "everything" for full account access
    /// - `redirect_uri`: Custom scheme URI for callback handling
    /// - `response_type`: "code" for authorization code flow
    ///
    /// - Returns: The OAuth authorization URL, or `nil` if URL construction fails
    public static func makeOAuthCodeRequestURL() -> URL? {
        let url = URL(string: "https://home.omg.lol/oauth/authorize")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        components?.queryItems = [
            .init(name: "client_id", value: Constant.Client.id),
            .init(name: "scope", value: "everything"),
            .init(name: "redirect_uri", value: Constant.Client.redirectURI),
            .init(name: "response_type", value: "code")
        ]

        return components?.url
    }

    /// Creates a request to exchange an OAuth authorization code for an access token.
    ///
    /// This method builds a GET request that completes the OAuth 2.0 authorization
    /// code flow by exchanging the received authorization code for an access token.
    /// The access token can then be used for authenticated API requests.
    ///
    /// The request includes all necessary OAuth parameters as query items:
    /// - `client_id` and `client_secret`: OAuth client credentials
    /// - `redirect_uri`: Must match the URI used in the authorization request
    /// - `code`: The authorization code received from the OAuth callback
    /// - `scope`: The requested permissions scope
    ///
    /// The request also includes a Bearer authorization header with an API token
    /// required for this specific OAuth endpoint.
    ///
    /// - Parameter code: The authorization code received from the OAuth callback
    /// - Returns: A configured network request for exchanging the code for an access token
    public static func makeAuthRequest(
        code: String
    ) -> NetworkRequest<VoidRequest, AccessTokenResponse> {
        .init(
            path: "/oauth",
            method: .get,
            queryItems: [
                .init(name: "client_id", value: Constant.Client.id),
                .init(name: "client_secret", value: Constant.Client.secret),
                .init(name: "redirect_uri", value: Constant.Client.redirectURI),
                .init(name: "code", value: code),
                .init(name: "scope", value: Constant.Client.scope)
            ]
        )
    }
}
