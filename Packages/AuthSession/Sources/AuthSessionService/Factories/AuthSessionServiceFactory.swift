import AuthSessionServiceInterface
import Foundation

/// A protocol for creating authentication session service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication session services with secure Keychain storage. The factory pattern
/// abstracts the complex initialization of the authentication service and its dependencies,
/// providing a clean interface for dependency injection and testing.
///
/// Implementations should configure the service with appropriate secure storage
/// mechanisms and any required dependencies for authentication state management.
public protocol AuthSessionServiceFactoryProtocol {

    /// Creates a new authentication session service instance.
    ///
    /// This method constructs a fully configured authentication session service
    /// with secure Keychain storage for access tokens. The service is initialized
    /// with any existing tokens from secure storage and is ready for immediate use.
    ///
    /// The created service handles:
    /// - Secure token storage and retrieval via Keychain
    /// - Authentication state management
    /// - Reactive streams for login state and logout events
    /// - Automatic token persistence across app launches
    ///
    /// - Returns: A configured `AuthSessionServiceProtocol` instance ready for use.
    func makeAuthSessionService() -> any AuthSessionServiceProtocol
}

public struct AuthSessionServiceFactory: AuthSessionServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthSessionService() -> any AuthSessionServiceProtocol {
        let store = KeychainStore(
            "Triton: Access Token"
        )

        return AuthSessionService(
            keychainStore: store
        )
    }
}
