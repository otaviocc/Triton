import MicroClient

/// A protocol for creating "Now" page network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// "Now" page network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Now page network services handle HTTP requests for "Now" page operations
/// including creating, updating, and retrieving user's current status or activity.
/// Implementations should configure the service with appropriate network clients
/// for API communication with "Now" page endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: NowNetworkServiceFactoryProtocol = NowNetworkServiceFactory()
/// let service = factory.makeNowNetworkService(networkClient: networkClient)
/// ```
public protocol NowNetworkServiceFactoryProtocol {

    /// Creates a new "Now" page network service instance.
    ///
    /// This method constructs a fully configured "Now" page network service with
    /// the provided HTTP client. The service handles "Now" page related network
    /// operations including updating and retrieving the user's current activity.
    ///
    /// The created service provides:
    /// - "Now" page content creation and updates
    /// - Current activity retrieval from remote endpoints
    /// - Real-time status synchronization
    /// - Proper error handling for network failures
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `NowNetworkServiceProtocol` instance ready for use.
    func makeNowNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any NowNetworkServiceProtocol
}

public struct NowNetworkServiceFactory: NowNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeNowNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any NowNetworkServiceProtocol {
        NowNetworkService(
            networkClient: networkClient
        )
    }
}
