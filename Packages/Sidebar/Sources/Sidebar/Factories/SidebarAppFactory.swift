import AuthSessionServiceInterface
import Route
import SwiftUI

/// Factory responsible for creating the sidebar navigation feature and its views.
///
/// `SidebarAppFactory` manages the application's sidebar navigation including feature
/// selection and routing. It initializes the sidebar environment with required dependencies
/// and provides methods to create fully configured sidebar views.
///
/// ## Usage
///
/// ```swift
/// let factory = SidebarAppFactory(
///     authSessionService: authSession
/// )
///
/// let sidebarView = factory.makeAppView(selection: $selectedFeature)
/// ```
public final class SidebarAppFactory {

    // MARK: - Properties

    private let environment: SidebarEnvironment

    // MARK: - Lifecycle

    public init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        environment = .init(
            authSessionService: authSessionService
        )
    }

    // MARK: - Public

    /// Creates the main sidebar navigation view.
    ///
    /// This method constructs the sidebar navigation view with all necessary dependencies
    /// injected. The view displays available features and manages navigation selection.
    ///
    /// - Parameter selection: A binding to the currently selected route feature.
    /// - Returns: A configured sidebar view ready for presentation.
    @MainActor
    public func makeAppView(
        selection: Binding<RouteFeature?>
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeSidebarViewModel()

        return SidebarView(
            viewModel: viewModel,
            selection: selection
        )
    }
}
