import Foundation

/// A factory protocol for creating clipboard service instances.
///
/// This protocol defines the interface for creating clipboard services that can handle
/// platform-specific clipboard operations. Implementations should provide appropriate
/// clipboard service instances based on the target platform (iOS, macOS, etc.).
///
/// ## Usage
///
/// ```swift
/// let factory: ClipboardServiceFactoryProtocol = ClipboardServiceFactory()
/// let clipboardService = factory.makeClipboardService()
/// ```
public protocol ClipboardServiceFactoryProtocol {

    /// Creates and returns a clipboard service instance.
    ///
    /// This method creates a platform-appropriate clipboard service that conforms to
    /// `ClipboardServiceProtocol`. The returned service handles clipboard operations
    /// specific to the current platform.
    ///
    /// - Returns: A clipboard service instance that conforms to `ClipboardServiceProtocol`.
    func makeClipboardService() -> ClipboardServiceProtocol
}

public struct ClipboardServiceFactory: ClipboardServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeClipboardService() -> any ClipboardServiceProtocol {
        let platformService: ClipboardServiceProtocol

        #if os(iOS)
            platformService = IOSClipboardService()
        #elseif os(macOS)
            platformService = MacOSClipboardService()
        #else
            fatalError("Unsupported platform")
        #endif

        return ClipboardService(
            service: platformService
        )
    }
}
