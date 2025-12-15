import AuthNetworkService
import AuthPersistenceService
import Foundation

/// Errors that can occur during authentication repository operations.
///
/// This enumeration defines the specific error cases that can arise when
/// working with authentication tokens and repository operations.
public enum AuthRepositoryError: Error {

    /// Indicates that no access token is available when one is required.
    ///
    /// This error is thrown when attempting to retrieve an access token
    /// but none has been stored, typically indicating the user is not
    /// authenticated or the token has been removed/expired.
    case missingToken
}

/// A repository protocol for managing authentication flow and token storage.
///
/// This protocol defines the interface for coordinating the complete authentication
/// process, from handling OAuth callbacks through secure token storage. It manages
/// the integration between network-based authentication operations and secure local
/// token persistence.
///
/// The repository handles the OAuth "authorization code" flow where users are redirected
/// to an external authentication provider, then redirected back to the application with
/// an authorization code that must be exchanged for an access token. It also provides
/// secure storage and retrieval of access tokens using the device's Keychain.
///
/// The repository follows the repository pattern, abstracting the complexities of
/// OAuth flows and secure storage to provide a clean interface for authentication
/// management throughout the application.
public protocol AuthRepositoryProtocol: Sendable {

    /// Handles OAuth callback URLs containing authorization codes.
    ///
    /// This method processes deep link URLs that result from OAuth authentication flows.
    /// When users complete authentication with the external provider, they are redirected
    /// back to the application with a URL containing an authorization code. This method:
    ///
    /// 1. Parses the URL to extract the authorization code
    /// 2. Validates that the URL is an authentication callback (host == "authenticate")
    /// 3. Exchanges the code for an access token via the network service
    /// 4. Securely stores the access token using the persistence service
    ///
    /// The method silently returns if the URL is not a valid authentication callback,
    /// allowing other URL handlers to process non-authentication deep links.
    ///
    /// - Parameter url: The deep link URL containing the OAuth authorization code.
    /// - Throws: Network errors from the token exchange or validation errors if the flow fails.
    func handleDeepLinkURL(
        _ url: URL
    ) async throws

    /// Stores an access token securely.
    ///
    /// This method provides a direct way to store an access token, typically used
    /// in scenarios where a token is obtained through means other than the standard
    /// OAuth deep link flow (such as manual token entry or alternative authentication methods).
    ///
    /// The token is stored securely using the same mechanism as tokens obtained
    /// through the OAuth flow, ensuring consistent security practices.
    ///
    /// - Parameter accessToken: The access token to store securely.
    func storeToken(
        accessToken: String
    ) async

    /// Retrieves the currently stored access token.
    ///
    /// This method returns the access token that was previously stored through
    /// authentication flows. The token can be used for authenticated API requests.
    ///
    /// - Returns: The stored access token.
    /// - Throws: `AuthRepositoryError.missingToken` if no token is available.
    func accessToken() async throws -> String

    /// Removes the stored access token and logs out the user.
    ///
    /// This method securely removes the access token from storage, effectively
    /// logging out the user. After calling this method, subsequent calls to
    /// `accessToken()` will throw `AuthRepositoryError.missingToken` until
    /// the user authenticates again.
    ///
    /// This operation also triggers logout events for components that observe
    /// authentication state changes.
    func removeAccessToken() async
}

actor AuthRepository: AuthRepositoryProtocol {

    // MARK: - Properties

    private let networkService: AuthNetworkServiceProtocol
    private let persistenceService: AuthPersistenceServiceProtocol

    // MARK: - Lifecycle

    init(
        networkService: AuthNetworkServiceProtocol,
        persistenceService: AuthPersistenceServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }

    // MARK: - Public

    func handleDeepLinkURL(
        _ url: URL
    ) async throws {
        let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )

        let host = components?.host
        let code = components?.queryItems?
            .first { $0.name == "code" }?
            .value

        guard host == "authenticate", let code else { return }

        let accessToken = try await networkService.accessToken(
            code: code
        )

        await persistenceService.storeAccessToken(
            value: accessToken
        )
    }

    func storeToken(
        accessToken: String
    ) async {
        await persistenceService.storeAccessToken(
            value: accessToken
        )
    }

    func accessToken() async throws -> String {
        guard let accessToken = await persistenceService.fetchAccessToken() else {
            throw AuthRepositoryError.missingToken
        }

        return accessToken
    }

    func removeAccessToken() async {
        await persistenceService.removeAccessToken()
    }
}
