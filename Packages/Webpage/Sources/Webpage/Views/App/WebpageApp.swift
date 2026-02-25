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

    private func makeWebpageListView(
        address: SelectedAddress
    ) -> some View {
        WebpageListView(
            viewModel: viewModelFactory.makeWebpageListViewModel(
                address: address
            )
        )
        .toolbar(id: "webpage") {
            makeToolbarContent(address: address)
        }
    }

    private func makeShareToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openComposeWindow(address: address)
        } label: {
            Label("Share", systemImage: "message")
        }
        .help("Share webpage")
    }

    private func makeWebpageToolbarItem(
        address: SelectedAddress
    ) -> some View {
        Button {
            openURL(URL(webpageFor: address))
        } label: {
            Label("Open Webpage", systemImage: "safari")
        }
        .help("Open webpage")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some CustomizableToolbarContent {
        ToolbarItem(
            id: "webpage.actions",
            placement: .automatic
        ) {
            ControlGroup {
                makeWebpageToolbarItem(
                    address: address
                )
                RefreshToolbarItem(
                    action: { viewModel.fetchWebpage() },
                    helpText: "Refresh webpage",
                    isDisabled: viewModel.disableRefreshButton
                )
                .keyboardShortcut("r", modifiers: .command)
                makeShareToolbarItem(
                    address: address
                )
            } label: {
                Label("Webpage Actions", systemImage: "safari")
            }
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
