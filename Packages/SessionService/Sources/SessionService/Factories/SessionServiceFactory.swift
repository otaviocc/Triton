import Archiver
import Foundation
import SessionServiceInterface

/// A protocol for factories that create session service instances.
///
/// This protocol defines the interface for creating `SessionServiceProtocol`
/// implementations. It follows the factory pattern to encapsulate the creation
/// and configuration of session services, allowing different implementations
/// or configurations to be used without changing client code.
///
/// The factory pattern is particularly useful for dependency injection systems
/// where the concrete session service implementation might vary based on
/// configuration, testing needs, or runtime conditions.
///
/// ## Usage Example
/// ```swift
/// let factory: SessionServiceFactoryProtocol = SessionServiceFactory()
/// let sessionService = factory.makeSessionService()
/// ```
public protocol SessionServiceFactoryProtocol {

    /// Creates a new session service instance.
    ///
    /// This method constructs and configures a session service with all necessary
    /// dependencies and settings. The returned service is ready to manage user
    /// session state and provide account information to the application.
    ///
    /// - Returns: A configured session service that implements `SessionServiceProtocol`
    func makeSessionService() -> any SessionServiceProtocol
}

public struct SessionServiceFactory: SessionServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeSessionService() -> any SessionServiceProtocol {
        guard
            let accountArchiver = try? Archiver<CurrentAccount>(),
            let addressArchiver = try? Archiver<SelectedAddress>()
        else {
            fatalError("Couldn't initialize the account Archiver")
        }

        return SessionService(
            accountArchiver: accountArchiver,
            addressArchiver: addressArchiver
        )
    }
}
