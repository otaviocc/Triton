import AuthSessionServiceInterface
import PicsNetworkService
import PicsPersistenceService
import SessionServiceInterface

/// A protocol for creating pictures repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// pictures repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Pictures repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for picture management
/// operations. They handle picture fetching, metadata management, and provide
/// seamless integration between remote API calls and local data storage for
/// offline access to picture collections.
///
/// ## Usage Example
/// ```swift
/// let factory: PicsRepositoryFactoryProtocol = PicsRepositoryFactory()
/// let repository = factory.makePicsRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol PicsRepositoryFactoryProtocol {

    /// Creates a new pictures repository instance.
    ///
    /// This method constructs a fully configured pictures repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive picture
    /// management capabilities including image fetching, metadata handling, and
    /// user context management.
    ///
    /// The created repository provides:
    /// - SomePicture fetching and synchronization with user ownership context
    /// - Local picture caching with SwiftData persistence
    /// - User authentication state integration for access control
    /// - Session-aware picture management for multi-user scenarios
    /// - Offline picture access through local storage
    /// - Automatic conversion between network and persistence models
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote picture operations.
    ///   - persistenceService: The persistence service for local data storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `PicsRepositoryProtocol` instance ready for use.
    func makePicsRepository(
        networkService: any PicsNetworkServiceProtocol,
        persistenceService: any PicsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PicsRepositoryProtocol
}

public struct PicsRepositoryFactory: PicsRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePicsRepository(
        networkService: any PicsNetworkServiceProtocol,
        persistenceService: any PicsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PicsRepositoryProtocol {
        PicsRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
