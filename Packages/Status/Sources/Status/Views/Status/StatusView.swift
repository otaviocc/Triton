import DesignSystem
import SwiftUI

struct StatusView: View {

    // MARK: - Properties

    @Environment(\.openURL) private var openURL
    @Environment(\.viewModelFactory) private var viewModelFactory

    private let viewModel: StatusViewModel

    // MARK: - Lifecycle

    init(
        viewModel: StatusViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .top) {
            makeIconView()

            VStack(alignment: .leading, spacing: 4) {
                AddressView(address: viewModel.address)
                makeMessageView()

                HStack {
                    makeClockView()
                    Spacer()
                    makeReplyView()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .card(viewModel.backgroundColorID)
        .contextMenu {
            makeContextualMenu()
        }
    }

    @ViewBuilder
    private func makeIconView() -> some View {
        Text(viewModel.icon)
            .font(.system(size: 56))
            .frame(width: 60, height: 60)
    }

    @ViewBuilder
    private func makeMessageView() -> some View {
        Text(LocalizedStringKey(viewModel.message))
            .font(.body)
            .foregroundColor(.black)
            .environment(\.openURL, OpenURLAction { url in
                openURL(url)
                return .handled
            })
    }

    @ViewBuilder
    private func makeClockView() -> some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .foregroundColor(.black)
                .font(.subheadline)

            Text(viewModel.relativeDate)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }

    @ViewBuilder
    private func makeReplyView() -> some View {
        if viewModel.replyURL != nil {
            Image(systemName: "message")
                .foregroundColor(.black)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeCopyStatusURLToClipboard()
        if viewModel.replyURL != nil {
            makeCopyReplyURLToClipboard()
        }
        Divider()
        makeOpenInBrowserItem()
        if viewModel.replyURL != nil {
            makeOpenReplyInBrowserItem()
        }
        Divider()
        makeMuteAddressItem()
    }

    @ViewBuilder
    private func makeOpenInBrowserItem() -> some View {
        Button {
            openURL(viewModel.statusURL)
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    @ViewBuilder
    private func makeOpenReplyInBrowserItem() -> some View {
        if let replyURL = viewModel.replyURL {
            Button {
                openURL(replyURL)
            } label: {
                Label("Open Reply in Browser", systemImage: "message")
            }
        }
    }

    @ViewBuilder
    private func makeMuteAddressItem() -> some View {
        Button {
            viewModel.muteAddress()
        } label: {
            Label(
                "Mute All @\(viewModel.address)'s Posts",
                systemImage: "speaker.slash.fill"
            )
        }
    }

    @ViewBuilder
    private func makeCopyStatusURLToClipboard() -> some View {
        Button {
            viewModel.copyStatusURLToClipboard()
        } label: {
            Label("Copy Status URL", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopyReplyURLToClipboard() -> some View {
        Button {
            viewModel.copyReplyURLToClipboard()
        } label: {
            Label("Copy Reply URL", systemImage: "link")
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        StatusView(
            viewModel: StatusViewModelMother.makeStatusViewModel()
        )
        .frame(width: 420)
    }

#endif
