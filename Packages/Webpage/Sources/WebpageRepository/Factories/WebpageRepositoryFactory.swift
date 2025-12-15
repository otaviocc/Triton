import AuthSessionServiceInterface
import SessionServiceInterface
import WebpageNetworkService
import WebpagePersistenceService

/// A protocol for creating webpage repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// webpage repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Webpage repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for webpage management
/// operations. They handle webpage content creation, editing, publishing, and
/// provide seamless integration between remote API calls and local data storage
/// for webpage content and metadata management.
///
/// ## Usage Example
/// ```swift
/// let factory: WebpageRepositoryFactoryProtocol = WebpageRepositoryFactory()
/// let repository = factory.makeWebpageRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol WebpageRepositoryFactoryProtocol {

    /// Creates a new webpage repository instance.
    ///
    /// This method constructs a fully configured webpage repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive webpage
    /// management capabilities including content authoring, publishing workflows,
    /// and user context management.
    ///
    /// The created repository provides:
    /// - Webpage content creation, editing, and publishing with user context
    /// - Webpage retrieval with personalization and access control
    /// - Draft management and version control capabilities
    /// - Real-time content synchronization between local and remote
    /// - User authentication state integration for access control
    /// - Session-aware content management and caching strategies
    /// - Offline editing support with intelligent sync capabilities
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote webpage operations.
    ///   - persistenceService: The persistence service for local content storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `WebpageRepositoryProtocol` instance ready for use.
    func makeWebpageRepository(
        networkService: any WebpageNetworkServiceProtocol,
        persistenceService: WebpagePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any WebpageRepositoryProtocol
}

public struct WebpageRepositoryFactory: WebpageRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWebpageRepository(
        networkService: any WebpageNetworkServiceProtocol,
        persistenceService: WebpagePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any WebpageRepositoryProtocol {
        WebpageRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
