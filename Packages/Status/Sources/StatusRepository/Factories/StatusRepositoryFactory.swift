import StatusNetworkService
import StatusPersistenceService

/// A protocol for creating status repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// status repositories with their required network and persistence service dependencies.
/// The factory pattern abstracts the complex initialization of repositories and enables
/// dependency injection of different service implementations.
///
/// Status repositories coordinate between network and persistence layers to provide
/// a unified interface for status management operations. They handle data synchronization,
/// caching strategies, and provide seamless integration between remote API calls and
/// local data storage for status updates and timeline management.
///
/// ## Usage Example
/// ```swift
/// let factory: StatusRepositoryFactoryProtocol = StatusRepositoryFactory()
/// let repository = factory.makeStatusRepository(
///     networkService: networkService,
///     persistenceService: persistenceService
/// )
/// ```
public protocol StatusRepositoryFactoryProtocol {

    /// Creates a new status repository instance.
    ///
    /// This method constructs a fully configured status repository with the provided
    /// network and persistence services. The repository coordinates between these
    /// services to provide comprehensive status management capabilities including
    /// data synchronization, offline support, and caching strategies.
    ///
    /// The created repository provides:
    /// - Status creation and publishing with offline queue support
    /// - Timeline retrieval with local caching and remote synchronization
    /// - Status editing and update operations
    /// - Status deletion with proper cleanup
    /// - Data synchronization between local storage and remote endpoints
    /// - Conflict resolution for concurrent modifications
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote status operations.
    ///   - persistenceService: The persistence service for local status storage.
    /// - Returns: A configured `StatusRepositoryProtocol` instance ready for use.
    func makeStatusRepository(
        networkService: StatusNetworkServiceProtocol,
        persistenceService: StatusPersistenceServiceProtocol
    ) -> StatusRepositoryProtocol
}

public struct StatusRepositoryFactory: StatusRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeStatusRepository(
        networkService: StatusNetworkServiceProtocol,
        persistenceService: StatusPersistenceServiceProtocol
    ) -> StatusRepositoryProtocol {
        StatusRepository(
            networkService: networkService,
            persistenceService: persistenceService
        )
    }
}
