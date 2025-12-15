import SwiftUI

/// Main view for the Account feature.
///
/// `AccountApp` is the root view that displays account information including
/// user details, addresses, and account management capabilities. It coordinates
/// the account feature's UI components and view models.
public struct AccountApp: View {

    // MARK: - Properties

    @State private var viewModel: AccountAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Lifecycle

    init(
        viewModel: AccountAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    public var body: some View {
        AccountView(
            viewModel: viewModelFactory.makeAccountViewModel()
        )
    }
}
