// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
