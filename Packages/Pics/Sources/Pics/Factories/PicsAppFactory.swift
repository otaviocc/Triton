import AuthSessionServiceInterface
import ClipboardService
import MicroClient
import SessionServiceInterface
import SwiftData
import SwiftUI

/// Factory responsible for creating the Pics (Some Pics) feature and its views.
///
/// `PicsAppFactory` manages the image hosting functionality including viewing, uploading,
/// and editing pictures on some.pics. It initializes the pics environment with required
/// dependencies and provides methods to create fully configured pics views.
///
/// ## Usage
///
/// ```swift
/// let factory = PicsAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let picsView = factory.makeAppView()
/// ```
public final class PicsAppFactory {

    // MARK: - Properties

    private let environment: PicsEnvironment

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

    /// Creates the main Pics feature view.
    ///
    /// This method constructs the pics feature's root view with all necessary
    /// dependencies injected. The view displays the gallery of uploaded pictures
    /// and provides access to uploading and editing functionality.
    ///
    /// - Returns: A configured pics view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makePicsAppViewModel()

        PicsApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the pics scenes.
    ///
    /// This method constructs both the upload and edit picture scenes for the pics feature.
    /// The upload scene provides keyboard shortcut support (Shift+Cmd+P) for quick access.
    ///
    /// - Returns: A configured group of scenes for picture management.
    @MainActor
    public func makeScene() -> some Scene {
        Group {
            UploadPictureScene(environment: environment)
            EditPictureScene(environment: environment)
        }
    }
}
