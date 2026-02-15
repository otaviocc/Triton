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

struct AccountDetailsView: View {

    // MARK: - Properties

    @State private var viewModel: AccountDetailsViewModel

    // MARK: - Lifecycle

    init(
        viewModel: AccountDetailsViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        Form {
            makeHeaderView()
            makeAddressesView()
        }
        .scrollContentBackground(.hidden)
        .padding(8)
        .formStyle(.columns)
    }

    // MARK: - Private

    @ViewBuilder
    private func makeHeaderView() -> some View {
        let registrationDate = viewModel
            .currentAccount
            .creation
            .formatted(
                date: .long,
                time: .omitted
            )

        Section("Account") {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.currentAccount.name)
                        .bold()
                        .foregroundStyle(.primary)

                    Text(viewModel.currentAccount.email)
                        .foregroundStyle(.secondary)

                    Text("Registered \(registrationDate)")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(.omgBackground)
        }
    }

    private func makeAddressesView() -> some View {
        Section("Addresses") {
            List {
                ForEach(viewModel.currentAccount.addresses, id: \.address) { address in
                    HStack {
                        AvatarView(address: address.address)
                        makeAddressView(address: address)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func makeAddressView(
        address: CurrentAccount.Address
    ) -> some View {
        let registrationDate = address
            .creation
            .formatted(
                .relative(
                    presentation: .named,
                    unitsStyle: .wide
                )
            )

        let formattedExpire = if let expire = address.expire {
            "Expires \(expire.formatted(.relative(presentation: .named, unitsStyle: .wide)))"
        } else {
            "🌟 Lifetime address"
        }

        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(address.address)
                        .bold()
                        .foregroundStyle(.primary)

                    Text("Registered \(registrationDate)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(formattedExpire)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if address.address == viewModel.selectedAddress {
                    Text("Current")
                        .textCase(.uppercase)
                        .font(.subheadline)
                } else {
                    Button {
                        withAnimation {
                            viewModel.selectAddress(address.address)
                        }
                    } label: {
                        Text("Use This")
                            .textCase(.uppercase)
                            .font(.subheadline)
                    }
                    .help("Switch to this address")
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        AccountDetailsView(
            viewModel: AccountDetailsViewModelMother.makeAccountDetailsViewModel()
        )
        .frame(width: 420)
    }

#endif
