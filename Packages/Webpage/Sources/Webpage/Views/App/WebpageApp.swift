import DesignSystem
import FoundationExtensions
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the Webpage feature.
///
/// `WebpageApp` is the root view that displays the user's personal webpage content.
/// It provides access to viewing the current webpage and editing the HTML content,
/// allowing users to create and maintain their custom web presence.
struct WebpageApp: View {

    // MARK: - Properties

    @State private var viewModel: WebpageAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: WebpageAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makeWebpageListView(
                address: current
            )
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeWebpageListView(
        address: SelectedAddress
    ) -> some View {
        WebpageListView(
            viewModel: viewModelFactory.makeWebpageListViewModel(
                address: address
            )
        )
        .toolbar {
            makeToolbarContent(address: address)
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
        .help("Share webpage")
    }

    @ViewBuilder
    private func makeWebpageToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openURL(URL(webpageFor: address))
        } label: {
            Image(systemName: "safari")
        }
        .help("Open webpage")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            makeWebpageToolbarItem(
                address: address
            )
            RefreshToolbarItem(
                action: { viewModel.fetchWebpage() },
                helpText: "Refresh webpage",
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
        let url = URL(webpageFor: address).absoluteString
        let message = "Check out my [webpage](\(url))"

        openWindow(
            id: ComposeWindow.id,
            value: ComposeStatus(
                message: message,
                emoji: "🔗"
            )
        )
    }
}
