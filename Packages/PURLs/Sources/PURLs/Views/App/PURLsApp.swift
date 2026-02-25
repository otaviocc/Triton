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
            .toolbar(id: "purls") {
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
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        ToolbarItem(
            id: "purls.sort",
            placement: .automatic
        ) {
            SelectionToolbarItem(
                options: PURLsListSort.allCases,
                selection: $sort,
                itemLabel: { $0.localizedTitle },
                style: SortSelectionToolbarItemStyle(),
                helpText: "Sort PURLs"
            )
        }

        ToolbarItem(
            id: "purls.actions",
            placement: .automatic
        ) {
            ControlGroup {
                RefreshToolbarItem(
                    action: { viewModel.fetchPURLs() },
                    helpText: "Refresh PURLs",
                    isDisabled: viewModel.disableRefreshButton
                )
                .keyboardShortcut("r", modifiers: .command)
                makeCreateNewPURLToolbarItem()
            } label: {
                Label("PURLs Actions", systemImage: "link")
            }
        }
    }

    private func makeCreateNewPURLToolbarItem() -> some View {
        Button {
            openWindow(id: AddPURLWindow.id)
        } label: {
            Label("New PURL", systemImage: "plus")
        }
        .help("Create new PURL")
        .keyboardShortcut("n", modifiers: .command)
        .disabled(viewModel.disableAddButton)
    }
}
