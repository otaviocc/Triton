import AuthSessionServiceInterface
import SwiftData

/// A protocol for creating PURLs persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// PURLs persistence services with their required dependencies. The factory
/// pattern abstracts the complex initialization of persistence services and enables
/// dependency injection of different storage configurations and session services.
///
/// PURLs persistence services handle local storage and retrieval of permanent URL
/// data using Swift Data framework. The service manages a SwiftData model container
/// and provides data persistence capabilities for PURL entities including URL
/// configurations, analytics data, and user-specific PURL collections.
/// Implementations should configure the service with appropriate session services
/// and storage options.
///
/// ## Usage Example
/// ```swift
/// let factory: PURLsPersistenceServiceFactoryProtocol = PURLsPersistenceServiceFactory()
/// let service = factory.makePURLsPersistenceService(
///     inMemory: false,
///     authSessionService: authSessionService
/// )
/// ```
public protocol PURLsPersistenceServiceFactoryProtocol {

    /// Creates a new PURLs persistence service instance.
    ///
    /// This method constructs a fully configured PURLs persistence service with
    /// the provided configuration and session service. The persistence service manages
    /// local storage of PURL data, analytics, and user collections using Swift Data framework.
    ///
    /// The created service provides:
    /// - Swift Data model container management for PURL entities
    /// - Local storage and retrieval of permanent URL configurations and metadata
    /// - Integration with session state for user-specific PURL collections
    /// - Analytics data caching and local storage
    /// - Configurable in-memory or persistent storage options
    /// - Draft management for PURL creation and editing workflows
    /// - Proper error handling for storage operations
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `PURLsPersistenceServiceProtocol` instance ready for use.
    func makePURLsPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> PURLsPersistenceServiceProtocol
}

public struct PURLsPersistenceServiceFactory: PURLsPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePURLsPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> PURLsPersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "purls",
            schema: .init([PURL.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: PURL.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return PURLsPersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
