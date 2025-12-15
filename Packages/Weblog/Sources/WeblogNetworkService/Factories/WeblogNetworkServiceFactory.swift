import MicroClient

/// A protocol for creating weblog network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// weblog network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Weblog network services handle HTTP requests for blog-related operations
/// including creating, updating, retrieving, and deleting blog entries and posts.
/// They also manage blog metadata, categories, tags, and publishing workflows.
/// Implementations should configure the service with appropriate network clients
/// for API communication with blog management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: WeblogNetworkServiceFactoryProtocol = WeblogNetworkServiceFactory()
/// let service = factory.makeWeblogNetworkService(networkClient: networkClient)
/// ```
public protocol WeblogNetworkServiceFactoryProtocol {

    /// Creates a new weblog network service instance.
    ///
    /// This method constructs a fully configured weblog network service with the
    /// provided HTTP client. The service handles blog-related network operations
    /// including CRUD operations for blog entries, publishing workflows, and
    /// metadata management.
    ///
    /// The created service provides:
    /// - Blog entry creation and publishing with content validation
    /// - Entry retrieval and timeline synchronization
    /// - Blog post update and editing capabilities with revision history
    /// - Draft management and publishing workflow support
    /// - Category and tag management for content organization
    /// - Blog metadata and configuration synchronization
    /// - RSS feed generation and syndication support
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `WeblogNetworkServiceProtocol` instance ready for use.
    func makeWeblogNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WeblogNetworkServiceProtocol
}

public struct WeblogNetworkServiceFactory: WeblogNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWeblogNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any WeblogNetworkServiceProtocol {
        WeblogNetworkService(
            networkClient: networkClient
        )
    }
}
