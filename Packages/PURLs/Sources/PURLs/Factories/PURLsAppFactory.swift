import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import SessionServiceInterface
import SwiftUI

/// Factory responsible for creating the PURLs (Permanent URLs) feature and its views.
///
/// `PURLsAppFactory` manages the PURL functionality including listing, creating, and managing
/// permanent URL redirects. It initializes the PURL environment with required dependencies
/// and provides methods to create fully configured PURL views.
///
/// ## Usage
///
/// ```swift
/// let factory = PURLsAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let purlsView = factory.makeAppView()
/// ```
public final class PURLsAppFactory {

    // MARK: - Properties

    private let environment: PURLsEnvironment

    // MARK: - Lifecycle

    public init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        environment = .init(
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService,
            clipboardService: clipboardService
        )
    }

    // MARK: - Public

    /// Creates the main PURLs feature view.
    ///
    /// This method constructs the PURLs feature's root view with all necessary
    /// dependencies injected. The view displays the list of permanent URLs and provides
    /// access to creation and management functionality.
    ///
    /// - Returns: A configured PURLs view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makePURLsAppViewModel()

        PURLsApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the add PURL scene.
    ///
    /// This method constructs a scene for creating permanent URLs in a dedicated window.
    /// The scene provides keyboard shortcut support (Shift+Cmd+U) for quick access.
    ///
    /// - Returns: A configured scene for PURL creation.
    @MainActor
    public func makeScene() -> some Scene {
        AddPURLScene(environment: environment)
    }
}
