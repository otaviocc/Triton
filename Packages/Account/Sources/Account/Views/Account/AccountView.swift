import DesignSystem
import SessionServiceInterface
import SwiftUI

struct AccountView: View {

    // MARK: - Properties

    @State private var viewModel: AccountViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Lifecycle

    init(
        viewModel: AccountViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makeAccountView()
    }

    // MARK: - Private

    @ViewBuilder
    private func makeAccountView() -> some View {
        switch viewModel.account {
        case .notSynchronized:
            EmptyView()
        case let .account(current):
            makeAccountDetailView(
                currentAccount: current
            )
        }
    }

    @ViewBuilder
    private func makeAccountDetailView(
        currentAccount: CurrentAccount
    ) -> some View {
        let viewModel = viewModelFactory
            .makeAccountDetailsViewModel(
                currentAccount: currentAccount
            )

        AccountDetailsView(
            viewModel: viewModel
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("No account") {
        AccountView(
            viewModel: AccountViewModelMother
                .makeAccountViewModel(
                    account: .notSynchronized
                )
        )
        .frame(width: 420)
    }

    #Preview("With account") {
        let environment = AccountEnvironmentMother.makeAccountEnvironment()

        AccountView(
            viewModel: AccountViewModelMother
                .makeAccountViewModel(
                    account: .account(
                        current: CurrentAccountMother.makeCurrent()
                    )
                )
        )
        .frame(width: 420)
        .environment(\.viewModelFactory, environment.viewModelFactory)
    }

#endif
