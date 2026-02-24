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
    private func makeWeblogConfigurationToolbarItem(
        address: SelectedAddress
    ) -> some View {
        let configurationURL = URL(weblogConfigurationFor: address)

        Button {
            openURL(configurationURL)
        } label: {
            Image(systemName: "gearshape")
        }
        .help("Open Weblog configuration")
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
                    status: nil,
                    tags: .init()
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
            makeWeblogConfigurationToolbarItem(
                address: address
            )
        }

        ToolbarItemGroup {
            SelectionToolbarItem(
                options: WeblogEntriesListSort.allCases,
                selection: $sort,
                itemLabel: { $0.localizedTitle },
                style: SortSelectionToolbarItemStyle(),
                helpText: "Sort entries"
            )
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
