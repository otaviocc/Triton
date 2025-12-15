import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import SessionServiceInterface
import SwiftUI

/// Factory responsible for creating the Pastebin feature and its views.
///
/// `PastebinAppFactory` manages the pastebin functionality including listing, creating,
/// and editing pastes. It initializes the pastebin environment with required dependencies
/// and provides methods to create fully configured pastebin views.
///
/// ## Usage
///
/// ```swift
/// let factory = PastebinAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let pastebinView = factory.makeAppView()
/// ```
public final class PastebinAppFactory {

    // MARK: - Properties

    private let environment: PastebinEnvironment

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

    /// Creates the main Pastebin feature view.
    ///
    /// This method constructs the pastebin feature's root view with all necessary
    /// dependencies injected. The view displays the list of pastes and provides
    /// access to creation and editing functionality.
    ///
    /// - Returns: A configured pastebin view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makePastebinAppViewModel()

        PastebinApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the pastebin scenes.
    ///
    /// This method constructs both the create and edit paste scenes for the pastebin feature.
    /// The create scene provides keyboard shortcut support (Shift+Cmd+V) for quick access.
    ///
    /// - Returns: A configured group of scenes for paste management.
    @MainActor
    public func makeScene() -> some Scene {
        Group {
            CreatePasteScene(environment: environment)
            EditPasteScene(environment: environment)
        }
    }
}
