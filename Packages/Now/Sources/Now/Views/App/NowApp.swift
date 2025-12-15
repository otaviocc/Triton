import DesignSystem
import FoundationExtensions
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the Now Page feature.
///
/// `NowApp` is the root view that displays the user's now page - a personal page
/// describing what someone is focused on at this point in their life. It provides
/// access to viewing, editing, and sharing the now page, as well as browsing the
/// public now page garden.
struct NowApp: View {

    // MARK: - Properties

    @State private var viewModel: NowAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: NowAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makePageListView(
                address: current
            )
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makePageListView(
        address: SelectedAddress
    ) -> some View {
        NowListView(
            viewModel: viewModelFactory
                .makeNowListViewModel(
                    address: address
                )
        )
        .toolbar {
            makeToolbarContent(
                address: address
            )
        }
    }

    @ViewBuilder
    private func makeShareToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openComposeWindow(address: address)
        } label: {
            Image(systemName: "message")
        }
        .help("Share now page")
    }

    @ViewBuilder
    private func makeGardenToolbarItem() -> some View {
        Button {
            openURL(.nowGardenURL)
        } label: {
            Image(systemName: "leaf.fill")
        }
        .help("Open garden")
    }

    @ViewBuilder
    private func makeOpenNowPageToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openURL(URL(nowPageFor: address))
        } label: {
            Image(systemName: "safari")
        }
        .help("Open now page")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            makeGardenToolbarItem()
        }

        #if os(macOS)
            if #available(macOS 26.0, *) {
                ToolbarSpacer(.fixed)
            }
        #endif

        ToolbarItemGroup {
            makeOpenNowPageToolbarItem(
                address: address
            )
            RefreshToolbarItem(
                action: { viewModel.fetchNow() },
                helpText: "Refresh now page",
                isDisabled: viewModel.disableRefreshButton
            )
            makeShareToolbarItem(
                address: address
            )
        }
    }

    private func openComposeWindow(
        address: SelectedAddress
    ) {
        let url = URL(nowPageFor: address).absoluteString
        let message = "Check out my [/now page](\(url))"

        openWindow(
            id: ComposeWindow.id,
            value: ComposeStatus(
                message: message,
                emoji: "🕐"
            )
        )
    }
}
