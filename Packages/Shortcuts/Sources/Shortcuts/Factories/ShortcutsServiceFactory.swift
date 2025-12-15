import Foundation

/// Factory protocol for creating `ShortcutsService` instances.
///
/// This factory provides dependency injection for the shortcuts service layer,
/// allowing test doubles to be substituted in test environments while maintaining
/// the same interface.
///
/// ## Usage
///
/// Factories are typically resolved through the dependency injection container
/// and used to create service instances with their dependencies properly configured:
///
/// ```swift
/// let factory: ShortcutsServiceFactoryProtocol = // ... from container
/// let service = factory.makeShortcutsServiceService()
/// service.setUpObservers(openWindow: openWindow)
/// ```
public protocol ShortcutsServiceFactoryProtocol {

    /// Creates a configured shortcuts service instance.
    ///
    /// The returned service is ready to observe App Intent notifications and coordinate
    /// window opening actions. It is configured with the default notification center for
    /// production use.
    ///
    /// - Returns: A fully configured service conforming to `ShortcutsServiceProtocol`
    func makeShortcutsService() -> ShortcutsServiceProtocol
}

public struct ShortcutsServiceFactory: ShortcutsServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeShortcutsService() -> any ShortcutsServiceProtocol {
        ShortcutsService(
            notificationCenter: NotificationCenter.default
        )
    }
}
