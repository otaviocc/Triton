import MicroClient

/// A factory protocol for creating pictures network service instances.
///
/// This protocol defines the interface for creating `PicsNetworkService` instances
/// with the required network client dependency. The factory pattern allows for
/// flexible dependency injection and testing by abstracting the creation process.
///
/// Implementations of this protocol are responsible for configuring the network
/// service with the appropriate network client for communicating with the OMG.LOL
/// pictures API endpoints.
public protocol PicsNetworkServiceFactoryProtocol {

    /// Creates a new pictures network service instance.
    ///
    /// This method creates and configures a `PicsNetworkService` with the provided
    /// network client. The network client handles the actual HTTP communication
    /// with the OMG.LOL API endpoints.
    ///
    /// The created service will be ready to perform pictures-related network
    /// operations such as fetching user pictures and uploading new pictures.
    ///
    /// - Parameter networkClient: The network client to use for API communication
    /// - Returns: A configured pictures network service instance
    func makePicsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PicsNetworkServiceProtocol
}

public struct PicsNetworkServiceFactory: PicsNetworkServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePicsNetworkService(
        networkClient: NetworkClientProtocol
    ) -> any PicsNetworkServiceProtocol {
        PicsNetworkService(
            networkClient: networkClient
        )
    }
}
