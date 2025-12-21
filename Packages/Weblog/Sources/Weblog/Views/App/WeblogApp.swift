import DesignSystem
import FoundationExtensions
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the Weblog feature.
///
/// `WeblogApp` is the root view that displays the list of weblog entries with
/// sorting capabilities. It provides access to creating new blog posts, editing
/// existing entries, and managing the weblog timeline.
struct WeblogApp: View {

    // MARK: - Properties

    @AppStorage(WeblogEntriesListSort.key) private var sort: WeblogEntriesListSort = .publishedDateDescending
    @State private var viewModel: WeblogAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: WeblogAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makeWeblogView()
    }

    // MARK: - Public

    @ViewBuilder
    private func makeWeblogView() -> some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makeWeblogListView(
                address: current
            )
            .toolbar {
                makeToolbarContent(address: current)
            }
        }
    }

    @ViewBuilder
    private func makeWeblogListView(
        address: SelectedAddress
    ) -> some View {
        WeblogEntriesListView(
            viewModel: viewModelFactory.makeWeblogEntriesListViewModel(
                address: address,
                sort: sort
            )
        )
        .id(sort)
    }

    @ViewBuilder
    private func makeWeblogToolbarItem(
        address: SelectedAddress
    ) -> some View {
        let weblogURL = URL(weblogFor: address)

        Button {
            openURL(weblogURL)
        } label: {
            Image(systemName: "safari")
        }
        .help("Open Weblog")
    }

    @ViewBuilder
    private func makeAddEntryToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openWindow(
                id: EditWeblogEntryWindow.id,
                value: EditWeblogEntry(
                    address: address,
                    body: "# Title of your post\n\nThis is the body of your post...",
                    date: .init(),
                    entryID: nil,
                    status: nil
                )
            )
        } label: {
            Image(systemName: "plus")
        }
        .help("Create new weblog entry")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            SelectionToolbarItem(
                options: WeblogEntriesListSort.allCases,
                selection: $sort,
                itemLabel: { $0.localizedTitle },
                helpText: "Sort entries"
            )
            .selectionToolbarItemStyle(SortSelectionToolbarItemStyle())
        }

        ToolbarItemGroup {
            makeWeblogToolbarItem(address: address)
            RefreshToolbarItem(
                action: { viewModel.fetchEntries() },
                helpText: "Refresh weblog entries",
                isDisabled: viewModel.isLoading
            )
            makeAddEntryToolbarItem(address: address)
        }
    }
}
