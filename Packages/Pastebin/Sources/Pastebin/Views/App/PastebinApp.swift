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
                style: SortSelectionToolbarItemStyle(),
                helpText: "Sort pastes"
            )
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
