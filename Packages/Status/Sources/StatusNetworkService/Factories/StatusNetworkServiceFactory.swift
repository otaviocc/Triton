import MicroClient

/// A protocol for creating status network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// status network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Status network services handle HTTP requests for status-related operations
/// including creating, updating, retrieving, and deleting user status updates.
/// Implementations should configure the service with appropriate network clients
/// for API communication with status endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: StatusNetworkServiceFactoryProtocol = StatusNetworkServiceFactory()
/// let service = factory.makeStatusNetworkService(networkClient: networkClient)
/// ```
public protocol StatusNetworkServiceFactoryProtocol {

    /// Creates a new status network service instance.
    ///
    /// This method constructs a fully configured status network service with the
    /// provided HTTP client. The service handles status-related network operations
    /// including CRUD operations for user status updates.
    ///
    /// The created service provides:
    /// - Status creation and publishing to remote endpoints
    /// - Status retrieval and timeline synchronization
    /// - Status update and editing capabilities
    /// - Status deletion and cleanup operations
    /// - Proper error handling for network failures
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `StatusNetworkServiceProtocol` instance ready for use.
    func makeStatusNetworkService(
        networkClient: NetworkClientProtocol
    ) -> StatusNetworkServiceProtocol
}

public struct StatusNetworkServiceFactory: StatusNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeStatusNetworkService(
        networkClient: NetworkClientProtocol
    ) -> StatusNetworkServiceProtocol {
        StatusNetworkService(
            networkClient: networkClient
        )
    }
}
