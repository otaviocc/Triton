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

/// Main view for the Pics (Some Pics) feature.
///
/// `PicsApp` is the root view that displays the gallery of uploaded pictures
/// on the some.pics subdomain. It provides access to uploading new pictures,
/// editing picture metadata, and managing the image gallery.
struct PicsApp: View {

    // MARK: - Properties

    @State private var viewModel: PicsAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: PicsAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makePicturesView()
    }

    // MARK: - Public

    @ViewBuilder
    private func makePicturesView() -> some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makePicturesListView(
                address: current
            )
            .toolbar {
                makeToolbarContent(address: current)
            }
        }
    }

    private func makePicturesListView(
        address: SelectedAddress
    ) -> some View {
        PicturesListView(
            viewModel: viewModelFactory.makePicturesListViewModel(
                address: address
            )
        )
    }

    @ViewBuilder
    private func makeSomePicsToolbarItem(
        address: SelectedAddress
    ) -> some View {
        let weblogURL = URL(somePicsFor: address)

        Button {
            openURL(weblogURL)
        } label: {
            Image(systemName: "safari")
        }
        .help("Open Some Pics")
    }

    private func makeUploadPictureToolbarItem() -> some View {
        Button {
            openWindow(id: UploadPictureWindow.id)
        } label: {
            Image(systemName: "plus")
        }
        .help("Upload new picture")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            makeSomePicsToolbarItem(address: address)
            RefreshToolbarItem(
                action: { viewModel.fetchPictures() },
                helpText: "Refresh pictures",
                isDisabled: viewModel.isLoading
            )
            makeUploadPictureToolbarItem()
        }
    }
}
