import AuthSessionServiceInterface
import Foundation
import PastebinNetworkService
import PastebinPersistenceService
import SessionServiceInterface

/// A protocol for creating pastebin repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// pastebin repositories with their required network, persistence, and session
/// service dependencies. The factory pattern abstracts the complex initialization
/// of repositories and enables dependency injection of different service implementations.
///
/// Pastebin repositories coordinate between network, persistence, authentication,
/// and session layers to provide a unified interface for paste management operations.
/// They handle paste creation, editing, sharing, and provide seamless integration
/// between remote API calls and local data storage for paste content, metadata,
/// and user-specific paste collections.
///
/// ## Usage Example
/// ```swift
/// let factory: PastebinRepositoryFactoryProtocol = PastebinRepositoryFactory()
/// let repository = factory.makePastebinRepository(
///     networkService: networkService,
///     persistenceService: persistenceService,
///     authSessionService: authSessionService,
///     sessionService: sessionService
/// )
/// ```
public protocol PastebinRepositoryFactoryProtocol {

    /// Creates a new pastebin repository instance.
    ///
    /// This method constructs a fully configured pastebin repository with the
    /// provided services. The repository coordinates between network, persistence,
    /// authentication, and session services to provide comprehensive paste
    /// management capabilities including content creation, sharing workflows,
    /// and user context management.
    ///
    /// The created repository provides:
    /// - Paste creation and publishing with syntax highlighting and language detection
    /// - Paste retrieval with personalization and access control
    /// - Content editing and version management capabilities
    /// - Draft management for multi-step paste creation workflows
    /// - Real-time synchronization between local cache and remote storage
    /// - User authentication state integration for private paste management
    /// - Session-aware paste collections and history tracking
    /// - Sharing and collaboration features with permission controls
    /// - Offline editing support with intelligent sync capabilities
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote paste operations.
    ///   - persistenceService: The persistence service for local paste storage.
    ///   - authSessionService: The authentication session service for user context.
    ///   - sessionService: The session service for user state management.
    /// - Returns: A configured `PastebinRepositoryProtocol` instance ready for use.
    func makePastebinRepository(
        networkService: any PastebinNetworkServiceProtocol,
        persistenceService: PastebinPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PastebinRepositoryProtocol
}

public struct PastebinRepositoryFactory: PastebinRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePastebinRepository(
        networkService: any PastebinNetworkServiceProtocol,
        persistenceService: PastebinPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) -> any PastebinRepositoryProtocol {
        PastebinRepository(
            networkService: networkService,
            persistenceService: persistenceService,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }
}
