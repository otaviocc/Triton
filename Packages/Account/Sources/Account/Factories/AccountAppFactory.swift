import AuthSessionServiceInterface
import MicroClient
import SessionServiceInterface
import SwiftUI

/// Factory responsible for creating the account management feature and its views.
///
/// `AccountAppFactory` manages the account information display including user details,
/// addresses, and account settings. It initializes the account environment with required
/// dependencies and provides methods to create fully configured account views.
///
/// ## Usage
///
/// ```swift
/// let factory = AccountAppFactory(
///     sessionService: sessionService
/// )
///
/// let accountView = factory.makeAppView()
/// ```
public final class AccountAppFactory {

    // MARK: - Properties

    private let environment: AccountEnvironment

    // MARK: - Lifecycle

    public init(
        sessionService: any SessionServiceProtocol
    ) {
        environment = .init(
            sessionService: sessionService
        )
    }

    // MARK: - Public

    /// Creates the main account management view.
    ///
    /// This method constructs the account feature's root view with all necessary
    /// dependencies injected. The view displays user account information including
    /// email, addresses, registration date, and address management capabilities.
    ///
    /// - Returns: A configured account view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeAccountViewModel()

        AccountView(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
    }
}
