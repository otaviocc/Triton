import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import SessionServiceInterface
import SwiftData
import SwiftUI

/// Factory responsible for creating the Weblog feature and its views.
///
/// `WeblogAppFactory` manages the weblog functionality including viewing the list of
/// blog entries, creating new posts, and editing existing posts. It initializes the
/// weblog environment with required dependencies and provides methods to create fully
/// configured weblog views.
///
/// ## Usage
///
/// ```swift
/// let factory = WeblogAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let weblogView = factory.makeAppView()
/// ```
public final class WeblogAppFactory {

    // MARK: - Properties

    private let environment: WeblogEnvironment

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

    /// Creates the main Weblog feature view.
    ///
    /// This method constructs the weblog feature's root view with all necessary
    /// dependencies injected. The view displays the list of blog entries and provides
    /// access to creation and editing functionality.
    ///
    /// - Returns: A configured weblog view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeWeblogAppViewModel()

        WeblogApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the edit weblog entry scene.
    ///
    /// This method constructs a scene for editing weblog entries in a dedicated window.
    /// The scene allows users to create or update blog posts with publication date control.
    ///
    /// - Returns: A configured scene for weblog entry editing.
    @MainActor
    public func makeScene() -> some Scene {
        EditWeblogEntryScene(environment: environment)
    }
}
