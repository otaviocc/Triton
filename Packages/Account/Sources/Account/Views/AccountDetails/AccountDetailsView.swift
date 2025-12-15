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
                        .foregroundColor(.primary)

                    Text(viewModel.currentAccount.email)
                        .foregroundColor(.secondary)

                    Text("Registered \(registrationDate)")
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(.omgBackground)
        }
    }

    @ViewBuilder
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
                        .foregroundColor(.primary)

                    Text("Registered \(registrationDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(formattedExpire)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
