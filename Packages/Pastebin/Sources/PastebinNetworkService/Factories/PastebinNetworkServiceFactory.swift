import MicroClient

/// A protocol for creating pastebin network service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// pastebin network services with their required HTTP client dependencies.
/// The factory pattern abstracts the complex initialization of network services
/// and enables dependency injection of different network client implementations.
///
/// Pastebin network services handle HTTP requests for paste-related operations
/// including creating, updating, retrieving, and deleting text pastes and code snippets.
/// Implementations should configure the service with appropriate network clients
/// for API communication with pastebin management endpoints.
///
/// ## Usage Example
/// ```swift
/// let factory: PastebinNetworkServiceFactoryProtocol = PastebinNetworkServiceFactory()
/// let service = factory.makePastebinNetworkService(networkClient: networkClient)
/// ```
public protocol PastebinNetworkServiceFactoryProtocol {

    /// Creates a new pastebin network service instance.
    ///
    /// This method constructs a fully configured pastebin network service with the
    /// provided HTTP client. The service handles paste-related network operations
    /// including CRUD operations for text pastes, code snippets, and related metadata.
    ///
    /// The created service provides:
    /// - Paste creation and publishing to remote endpoints
    /// - Paste retrieval and content synchronization
    /// - Paste update and editing capabilities with version control
    /// - Paste deletion and cleanup operations
    /// - Syntax highlighting and language detection support
    /// - Proper error handling for network failures and validation errors
    ///
    /// - Parameter networkClient: The network client used to perform HTTP requests.
    /// - Returns: A configured `PastebinNetworkServiceProtocol` instance ready for use.
    func makePastebinNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PastebinNetworkServiceProtocol
}

public struct PastebinNetworkServiceFactory: PastebinNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePastebinNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PastebinNetworkServiceProtocol {
        PastebinNetworkService(
            networkClient: networkClient
        )
    }
}
