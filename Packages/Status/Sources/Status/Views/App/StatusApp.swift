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
        .toolbar(id: "status") {
            makeToolbarContent()
        }
    }

    // MARK: - Private

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        ToolbarItem(
            id: "status.filter",
            placement: .automatic
        ) {
            SelectionToolbarItem(
                options: StatusListFilter.allCases,
                selection: $filter,
                itemLabel: { label in label.localizedTitle },
                style: FilterSelectionToolbarItemStyle()
            )
        }

        ToolbarItem(
            id: "status.compose",
            placement: .automatic
        ) {
            makeCreateNewStatusToolbarItem()
        }
    }

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
        .keyboardShortcut("n", modifiers: .command)
        .disabled(viewModel.disableComposeButton)
    }
}
