import DesignSystem
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the PURLs (Permanent URLs) feature.
///
/// `PURLsApp` is the root view that displays the list of permanent URL redirects.
/// It provides sorting capabilities, creation of new PURLs, and management of existing
/// permanent URLs for short, memorable links.
public struct PURLsApp: View {

    // MARK: - Properties

    @AppStorage(PURLsListSort.key) private var sort: PURLsListSort = .nameAscending
    @State private var viewModel: PURLsAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow

    // MARK: - Lifecycle

    init(
        viewModel: PURLsAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    public var body: some View {
        makePURLsView()
            .toolbar {
                makeToolbarContent()
            }
    }

    // MARK: - Private

    @ViewBuilder
    private func makePURLsView() -> some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makePURLsListView(address: current)
        }
    }

    @ViewBuilder
    private func makePURLsListView(
        address: SelectedAddress
    ) -> some View {
        PURLsListView(
            viewModel: viewModelFactory
                .makePURLsListViewModel(
                    address: address,
                    sort: sort
                )
        )
        .id(sort)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            SelectionToolbarItem(
                options: PURLsListSort.allCases,
                selection: $sort,
                itemLabel: { $0.localizedTitle },
                helpText: "Sort PURLs"
            )
            .selectionToolbarItemStyle(SortSelectionToolbarItemStyle())
        }

        ToolbarItemGroup {
            RefreshToolbarItem(
                action: { viewModel.fetchPURLs() },
                helpText: "Refresh PURLs",
                isDisabled: viewModel.disableRefreshButton
            )
            makeCreateNewPURLToolbarItem()
        }
    }

    @ViewBuilder
    private func makeCreateNewPURLToolbarItem() -> some View {
        Button {
            openWindow(id: AddPURLWindow.id)
        } label: {
            Image(systemName: "plus")
        }
        .help("Create new PURL")
        .disabled(viewModel.disableAddButton)
    }
}
