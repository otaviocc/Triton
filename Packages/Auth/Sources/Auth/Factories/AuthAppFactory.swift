import AuthSessionServiceInterface
import MicroClient
import SwiftUI

/// Factory responsible for creating the authentication feature and its views.
///
/// `AuthAppFactory` manages the authentication flow including login and logout functionality.
/// It initializes the authentication environment with required dependencies and provides
/// methods to create fully configured authentication views.
///
/// ## Usage
///
/// ```swift
/// let factory = AuthAppFactory(
///     authSessionService: authSession,
///     networkClient: client
/// )
///
/// let authView = factory.makeAppView()
/// ```
public final class AuthAppFactory {

    // MARK: - Properties

    private let environment: AuthEnvironment

    // MARK: - Lifecycle

    public init(
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        environment = .init(
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    // MARK: - Public

    /// Creates the main authentication view.
    ///
    /// This method constructs the authentication feature's root view with all necessary
    /// dependencies injected. The view handles the complete authentication flow including
    /// login, logout, and session management.
    ///
    /// - Returns: A configured authentication view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeAuthAppViewModel()

        AuthApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
    }
}
