import SwiftUI

/// Main view for the Authentication feature.
///
/// `AuthApp` is the root view that manages the authentication flow, displaying
/// either the login view when the user is not authenticated or the logout view
/// when authenticated. It coordinates the authentication state and view transitions.
public struct AuthApp: View {

    // MARK: - Properties

    @State private var viewModel: AuthAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Lifecycle

    init(
        viewModel: AuthAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    public var body: some View {
        if viewModel.isLoggedIn {
            LogoutView(
                viewModel: viewModelFactory.makeLogoutViewModel()
            )
        } else {
            LoginView(
                viewModel: viewModelFactory.makeLoginViewModel()
            )
        }
    }
}
