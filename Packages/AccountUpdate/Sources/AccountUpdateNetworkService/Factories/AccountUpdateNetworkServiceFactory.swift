import MicroClient

/// A protocol for creating account update network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// account update network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Account update network services handle HTTP requests for account-related operations
/// including profile updates, settings modifications, and account information retrieval.
/// Implementations should configure the service with appropriate network clients
/// for API communication with account management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: AccountUpdateNetworkServiceFactoryProtocol = AccountUpdateNetworkServiceFactory()
/// let service = factory.makeAccountUpdateNetworkService(networkClient: networkClient)
/// ```
public protocol AccountUpdateNetworkServiceFactoryProtocol {

    /// Creates a new account update network service instance.
    ///
    /// This method constructs a fully configured account update network service with
    /// the provided HTTP client. The service handles account-related network operations
    /// including profile updates, settings changes, and account information synchronization.
    ///
    /// The created service provides:
    /// - Account profile update operations via HTTP APIs
    /// - Account settings modification and retrieval
    /// - User preference synchronization with remote endpoints
    /// - Account information validation and submission
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `AccountUpdateNetworkServiceProtocol` instance ready for use.
    func makeAccountUpdateNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AccountUpdateNetworkServiceProtocol
}

public struct AccountUpdateNetworkServiceFactory: AccountUpdateNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeAccountUpdateNetworkService(
        networkClient: NetworkClientProtocol
    ) -> AccountUpdateNetworkServiceProtocol {
        AccountUpdateNetworkService(
            networkClient: networkClient
        )
    }
}
