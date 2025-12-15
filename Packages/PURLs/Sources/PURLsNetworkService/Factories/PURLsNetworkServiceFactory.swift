import MicroClient

/// A protocol for creating PURLs network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// PURLs (Permanent URLs) network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// PURLs network services handle HTTP requests for permanent URL operations
/// including creating, updating, retrieving, and deleting custom URL redirections.
/// They also manage analytics data and redirection statistics. Implementations
/// should configure the service with appropriate network clients for API
/// communication with PURL management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: PURLsNetworkServiceFactoryProtocol = PURLsNetworkServiceFactory()
/// let service = factory.makePURLsNetworkService(networkClient: networkClient)
/// ```
public protocol PURLsNetworkServiceFactoryProtocol {

    /// Creates a new PURLs network service instance.
    ///
    /// This method constructs a fully configured PURLs network service with the
    /// provided HTTP client. The service handles permanent URL-related network
    /// operations including CRUD operations for custom redirections, analytics
    /// tracking, and redirection management.
    ///
    /// The created service provides:
    /// - PURL creation and configuration with custom paths and targets
    /// - URL redirection management and target updates
    /// - Analytics retrieval and statistics tracking
    /// - PURL deletion and cleanup operations
    /// - Bulk operations for managing multiple PURLs
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `PURLsNetworkServiceProtocol` instance ready for use.
    func makePURLsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PURLsNetworkServiceProtocol
}

public struct PURLsNetworkServiceFactory: PURLsNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePURLsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PURLsNetworkServiceProtocol {
        PURLsNetworkService(
            networkClient: networkClient
        )
    }
}
