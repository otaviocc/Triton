import DesignSystem
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the Pastebin feature.
///
/// `PastebinApp` is the root view that displays the list of pastes with sorting
/// capabilities. It provides access to creating new pastes, editing existing ones,
/// and managing paste visibility in the public directory.
public struct PastebinApp: View {

    // MARK: - Properties

    @AppStorage(PastesListSort.key) private var sort: PastesListSort = .titleAscending
    @State private var viewModel: PastebinAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow

    // MARK: - Lifecycle

    init(
        viewModel: PastebinAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    public var body: some View {
        makePastesView()
            .toolbar {
                makeToolbarContent()
            }
    }

    // MARK: - Private

    @ViewBuilder
    private func makePastesView() -> some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makePastesListView(address: current)
        }
    }

    @ViewBuilder
    private func makePastesListView(
        address: SelectedAddress
    ) -> some View {
        PastesListView(
            viewModel: viewModelFactory
                .makePastesListViewModel(
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
                options: PastesListSort.allCases,
                selection: $sort,
                itemLabel: { $0.localizedTitle },
                helpText: "Sort pastes"
            )
            .selectionToolbarItemStyle(SortSelectionToolbarItemStyle())
        }

        ToolbarItemGroup {
            RefreshToolbarItem(
                action: { viewModel.fetchPastes() },
                helpText: "Refresh pastes",
                isDisabled: viewModel.disableRefreshButton
            )
            makeCreateNewPasteToolbarItem()
        }
    }

    @ViewBuilder
    private func makeCreateNewPasteToolbarItem() -> some View {
        Button {
            openWindow(id: CreatePasteWindow.id)
        } label: {
            Image(systemName: "plus")
        }
        .help("Create new paste")
        .disabled(viewModel.disableAddButton)
    }
}
