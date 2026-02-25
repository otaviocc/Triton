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

    private func makePageListView(
        address: SelectedAddress
    ) -> some View {
        NowListView(
            viewModel: viewModelFactory
                .makeNowListViewModel(
                    address: address
                )
        )
        .toolbar(id: "now") {
            makeToolbarContent(
                address: address
            )
        }
    }

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

    private func makeGardenToolbarItem() -> some View {
        Button {
            openURL(.nowGardenURL)
        } label: {
            Image(systemName: "leaf.fill")
        }
        .help("Open garden")
    }

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
    ) -> some CustomizableToolbarContent {
        ToolbarItem(
            id: "now.garden",
            placement: .automatic
        ) {
            makeGardenToolbarItem()
        }

        #if os(macOS)
            if #available(macOS 26.0, *) {
                ToolbarSpacer(.fixed)
            }
        #endif

        ToolbarItem(
            id: "now.actions",
            placement: .automatic
        ) {
            ControlGroup {
                makeOpenNowPageToolbarItem(
                    address: address
                )
                RefreshToolbarItem(
                    action: { viewModel.fetchNow() },
                    helpText: "Refresh now page",
                    isDisabled: viewModel.disableRefreshButton
                )
                .keyboardShortcut("r", modifiers: .command)
                makeShareToolbarItem(
                    address: address
                )
            } label: {
                Label("Now Page Actions", systemImage: "clock")
            }
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
