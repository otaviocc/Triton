import DesignSystem
import FoundationExtensions
import SwiftUI

struct ProfileView: View {

    // MARK: - Properties

    @State private var viewModel: ProfileViewModel
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: ProfileViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .center) {
            AvatarView(address: viewModel.address)

            VStack(alignment: .leading) {
                Text(viewModel.formattedAddress)
                    .font(.headline)

                HStack(alignment: .center, spacing: 8) {
                    makeWebpageView()
                    makeNowPageView()
                    makeWeblogView()
                }
                .buttonStyle(.borderless)
                .foregroundColor(.accentColor)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Private

    @ViewBuilder
    private func makeWebpageView() -> some View {
        let url = URL(webpageFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Webpage", systemImage: "safari")
        }
        .help("Open webpage in browser")
        .labelStyle(.distanced)
    }

    @ViewBuilder
    private func makeNowPageView() -> some View {
        let url = URL(nowPageFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Now Page", systemImage: "clock")
        }
        .help("Open now page in browser")
        .labelStyle(.distanced)
    }

    @ViewBuilder
    private func makeWeblogView() -> some View {
        let url = URL(weblogFor: viewModel.address)

        Button {
            openURL(url)
        } label: {
            Label("Weblog", systemImage: "text.below.photo")
        }
        .help("Open weblog in browser")
        .labelStyle(.distanced)
    }
}

// MARK: - Preview

#Preview {
    ProfileView(
        viewModel: .init(
            address: "otaviocc"
        )
    )
    .frame(width: 400)
}
