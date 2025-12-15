import AuthSessionServiceInterface
import SwiftData

/// A protocol for creating status persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// status persistence services with their required dependencies. The factory pattern
/// abstracts the complex initialization of persistence services and enables
/// dependency injection of different storage configurations and session services.
///
/// Status persistence services handle local storage and retrieval of status updates
/// using Swift Data framework. The service manages a SwiftData model container
/// and provides data persistence capabilities for status entities. Implementations
/// should configure the service with appropriate session services and storage options.
///
/// ## Usage Example
/// ```swift
/// let factory: StatusPersistenceServiceFactoryProtocol = StatusPersistenceServiceFactory()
/// let service = factory.makeStatusPersistenceService(
///     inMemory: false,
///     authSessionService: sessionService
/// )
/// ```
public protocol StatusPersistenceServiceFactoryProtocol {

    /// Creates a new status persistence service instance.
    ///
    /// This method constructs a fully configured status persistence service with
    /// the provided configuration and session service. The persistence service
    /// manages local storage of status updates using Swift Data framework.
    ///
    /// The created service provides:
    /// - Swift Data model container management for Status entities
    /// - Local storage and retrieval of status updates
    /// - Integration with session state for user-specific data
    /// - Configurable in-memory or persistent storage options
    /// - Proper error handling for storage operations
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `StatusPersistenceServiceProtocol` instance ready for use.
    func makeStatusPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> StatusPersistenceServiceProtocol
}

public struct StatusPersistenceServiceFactory: StatusPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeStatusPersistenceService(
        inMemory: Bool = false,
        authSessionService: any AuthSessionServiceProtocol
    ) -> StatusPersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "status",
            schema: .init([Status.self, MutedAddress.self, MutedKeyword.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: Status.self,
            MutedAddress.self,
            MutedKeyword.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return StatusPersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
