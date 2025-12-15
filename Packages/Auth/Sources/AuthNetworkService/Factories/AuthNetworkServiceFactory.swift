import MicroClient

/// A protocol for creating authentication network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// authentication network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Authentication network services handle OAuth-related HTTP requests including
/// authorization code exchange for access tokens. Implementations should configure
/// the service with appropriate network clients for API communication.
///
/// ## Usage Example
/// ```swift
/// let factory: AuthNetworkServiceFactoryProtocol = AuthNetworkServiceFactory()
/// let service = factory.makeAuthNetworkService(networkClient: networkClient)
/// ```
public protocol AuthNetworkServiceFactoryProtocol {

    /// Creates a new authentication network service instance.
    ///
    /// This method constructs a fully configured authentication network service
    /// with the provided HTTP client. The service handles OAuth token exchange
    /// requests and other authentication-related network operations.
    ///
    /// The created service provides:
    /// - OAuth authorization code to access token exchange
    /// - HTTP client abstraction for network operations
    /// - Proper error handling for authentication failures
    /// - Integration with the broader authentication system
    ///
    /// - Parameter networkClient: The network client for performing HTTP requests.
    /// - Returns: A configured `AuthNetworkServiceProtocol` instance ready for use.
    func makeAuthNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AuthNetworkServiceProtocol
}

public struct AuthNetworkServiceFactory: AuthNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAuthNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AuthNetworkServiceProtocol {
        AuthNetworkService(
            networkClient: networkClient
        )
    }
}
