import DesignSystem
import Route
import SwiftUI

/// Main view for the Statuslog feature.
///
/// `StatusApp` is the root view that displays the status timeline, showing a chronological
/// list of status updates. It provides access to composing new status updates and viewing
/// the full statuslog history.
public struct StatusApp: View {

    // MARK: - Properties

    @AppStorage(StatusListFilter.key) private var filter: StatusListFilter = .all
    @State private var viewModel: StatusAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow

    // MARK: - Lifecycle

    init(
        viewModel: StatusAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    public var body: some View {
        StatusListView(
            viewModel: viewModelFactory.makeStatusListViewModel(
                filter: filter
            )
        )
        .id(filter)
        .toolbar {
            makeToolbarContent()
        }
    }

    // MARK: - Private

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            SelectionToolbarItem(
                options: StatusListFilter.allCases,
                selection: $filter,
                itemLabel: { $0.localizedTitle }
            )
            .selectionToolbarItemStyle(FilterSelectionToolbarItemStyle())
        }

        ToolbarItemGroup {
            makeCreateNewStatusToolbarItem()
        }
    }

    @ViewBuilder
    private func makeCreateNewStatusToolbarItem() -> some View {
        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: ""
                )
            )
        } label: {
            Image(systemName: "square.and.pencil")
        }
        .help("Compose new status")
        .disabled(viewModel.disableComposeButton)
    }
}
