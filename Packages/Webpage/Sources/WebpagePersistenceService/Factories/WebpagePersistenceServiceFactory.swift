import AuthSessionServiceInterface
import SwiftData

/// A protocol for creating webpage persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// webpage persistence services with their required dependencies. The factory
/// pattern abstracts the complex initialization of persistence services and enables
/// dependency injection of different storage configurations and session services.
///
/// Webpage persistence services handle local storage and retrieval of web content
/// using Swift Data framework. The service manages a SwiftData model container
/// and provides data persistence capabilities for webpage entities including content,
/// metadata, draft versions, and user-specific webpage collections.
/// Implementations should configure the service with appropriate session services
/// and storage options.
///
/// ## Usage Example
/// ```swift
/// let factory: WebpagePersistenceServiceFactoryProtocol = WebpagePersistenceServiceFactory()
/// let service = factory.makeWebpagePersistenceService(
///     inMemory: false,
///     authSessionService: authSessionService
/// )
/// ```
public protocol WebpagePersistenceServiceFactoryProtocol {

    /// Creates a new webpage persistence service instance.
    ///
    /// This method constructs a fully configured webpage persistence service with
    /// the provided configuration and session service. The persistence service manages
    /// local storage of webpage content, drafts, and user collections using Swift Data framework.
    ///
    /// The created service provides:
    /// - Swift Data model container management for Webpage entities
    /// - Local storage and retrieval of webpage content and metadata
    /// - Integration with session state for user-specific content collections
    /// - Draft management and version control for content editing workflows
    /// - Content revision history and backup capabilities
    /// - Configurable in-memory or persistent storage options
    /// - Media and asset caching for offline content editing
    /// - Proper error handling for storage operations
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `WebpagePersistenceServiceProtocol` instance ready for use.
    func makeWebpagePersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> WebpagePersistenceServiceProtocol
}

public struct WebpagePersistenceServiceFactory: WebpagePersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWebpagePersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> WebpagePersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "webpage",
            schema: .init([Webpage.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: Webpage.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return WebpagePersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
