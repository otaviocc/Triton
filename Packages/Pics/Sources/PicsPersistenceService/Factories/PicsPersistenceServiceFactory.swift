import AuthSessionServiceInterface
import SwiftData

/// A protocol for creating pictures persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// pictures persistence services with their required dependencies. The factory pattern
/// abstracts the complex initialization of persistence services, including SwiftData
/// container setup, and enables dependency injection for different configurations.
///
/// Pictures persistence services handle local storage and synchronization of picture
/// collections using SwiftData. Implementations should configure the service with
/// appropriate SwiftData containers and session services for state management.
///
/// ## Usage Example
/// ```swift
/// let factory: PicsPersistenceServiceFactoryProtocol = PicsPersistenceServiceFactory()
/// let service = factory.makePicsPersistenceService(
///     inMemory: false,
///     authSessionService: sessionService
/// )
/// ```
public protocol PicsPersistenceServiceFactoryProtocol {

    /// Creates a new pictures persistence service instance.
    ///
    /// This method constructs a fully configured pictures persistence service with
    /// a SwiftData container and the provided session service. The persistence service
    /// handles local storage of picture collections, synchronization operations, and
    /// automatic cleanup when users log out.
    ///
    /// The created service provides:
    /// - SwiftData-based picture storage with unique constraints
    /// - Synchronization with remote picture collections
    /// - Automatic cleanup on user logout
    /// - Support for offline picture management
    /// - Thread-safe operations using MainActor constraints
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state and logout events.
    /// - Returns: A configured `PicsPersistenceServiceProtocol` instance ready for use.
    func makePicsPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> PicsPersistenceServiceProtocol
}

public struct PicsPersistenceServiceFactory: PicsPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makePicsPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> any PicsPersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "pictures",
            schema: .init([SomePicture.self, SomeTag.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: SomePicture.self, SomeTag.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return PicsPersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
