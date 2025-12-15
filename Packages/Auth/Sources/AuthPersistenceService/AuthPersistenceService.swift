import AuthSessionServiceInterface
import Foundation

/// A protocol for managing secure persistence of authentication tokens.
///
/// This protocol defines the interface for secure storage and retrieval of access tokens
/// using the device's secure storage mechanisms. It acts as an abstraction layer over
/// the AuthSessionService, providing a clean interface for authentication-related
/// persistence operations.
///
/// The service ensures that access tokens are stored securely using the device's Keychain,
/// providing protection against unauthorized access and ensuring tokens persist across
/// app launches and system reboots. All token operations are performed asynchronously
/// to maintain responsive UI performance.
///
/// This persistence layer integrates with the broader authentication system to provide
/// reactive token state management and automatic cleanup during logout operations.
public protocol AuthPersistenceServiceProtocol: AnyObject, Sendable {

    /// Retrieves the currently stored access token.
    ///
    /// This method fetches the access token that was previously stored in secure storage.
    /// The token is retrieved from the device's Keychain through the authentication
    /// session service, ensuring secure access to sensitive authentication data.
    ///
    /// - Returns: The stored access token, or `nil` if no token is available.
    func fetchAccessToken() async -> String?

    /// Securely stores an access token.
    ///
    /// This method saves the provided access token to secure storage using the device's
    /// Keychain. The token will persist across app launches and be available for
    /// authenticated API requests until explicitly removed or replaced.
    ///
    /// Storing a token automatically updates the authentication state, triggering
    /// notifications to components that observe authentication state changes.
    ///
    /// - Parameter value: The access token to store securely.
    func storeAccessToken(value: String) async

    /// Removes the stored access token and logs out the user.
    ///
    /// This method securely removes the access token from storage, effectively
    /// logging out the user. The token is permanently deleted from the device's
    /// Keychain and cannot be recovered.
    ///
    /// Removing a token automatically updates the authentication state to unauthenticated
    /// and triggers logout events for components that observe authentication changes,
    /// enabling automatic cleanup of user data and UI state.
    func removeAccessToken() async
}

actor AuthPersistenceService: AuthPersistenceServiceProtocol {

    // MARK: - Properties

    private let authSessionService: any AuthSessionServiceProtocol

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.authSessionService = authSessionService
    }

    // MARK: - Public

    func fetchAccessToken() async -> String? {
        await authSessionService.accessToken
    }

    func storeAccessToken(
        value: String
    ) async {
        await authSessionService.setAccessToken(value)
    }

    func removeAccessToken() async {
        await authSessionService.setAccessToken(nil)
    }
}
