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

struct PictureView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: PictureViewModel

    // MARK: - Lifecycle

    init(
        viewModel: PictureViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makePictureView()
            .onTapGesture(count: 2) {
                openEditor()
            }
            .contextMenu {
                makeContextualMenu()
            }
            .deleteConfirmation(isPresented: $showDeleteConfirmation) {
                viewModel.delete()
            }
    }

    // MARK: - Private

    private func makePictureView() -> some View {
        GeometryReader { geometry in
            AsyncImage(url: viewModel.photoURL?.imagePreviewURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.width
            )
            .clipped()
            .clipShape(.rect(cornerRadius: 8))
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeEditPictureMenuItem()
        Divider()
        makeCopyPhotoURLMenuItem()
        makeCopySomePicsURLMenuItem()
        makeCopyMarkdownLinkMenuItem()
        makeCopyMarkdownImageMenuItem()
        Divider()
        makeOpenInBrowserMenuItem()
        makeShareMenuItem()
        makeShareOnStatuslogMenuItem()
        Divider()
        makeDeletePictureMenuItem()
    }

    private func makeEditPictureMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Picture Description", systemImage: "pencil")
        }
    }

    private func makeCopyPhotoURLMenuItem() -> some View {
        Button {
            viewModel.copyPhotoURLToClipboard()
        } label: {
            Label("Copy Picture URL", systemImage: "link")
        }
    }

    private func makeCopySomePicsURLMenuItem() -> some View {
        Button {
            viewModel.copySomePicsURLToClipboard()
        } label: {
            Label("Copy Some Pics URL", systemImage: "link")
        }
    }

    private func makeCopyMarkdownLinkMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownLinkToClipboard()
        } label: {
            Label("Copy as Markdown Link", systemImage: "doc.text")
        }
    }

    private func makeCopyMarkdownImageMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownImageToClipboard()
        } label: {
            Label("Copy as Markdown Image", systemImage: "photo")
        }
    }

    @ViewBuilder
    private func makeOpenInBrowserMenuItem() -> some View {
        if let somePicsURL = viewModel.somePicsURL {
            Button {
                openURL(somePicsURL)
            } label: {
                Label("Open in Browser", systemImage: "safari")
            }
        }
    }

    @ViewBuilder
    private func makeShareMenuItem() -> some View {
        if let somePicsURL = viewModel.somePicsURL {
            ShareLink(item: somePicsURL) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }

    private func makeShareOnStatuslogMenuItem() -> some View {
        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: viewModel.markdownLink ?? "",
                    emoji: "📷"
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
        }
    }

    private func makeDeletePictureMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete Picture", systemImage: "trash")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditPictureWindow.id,
            value: EditPicture(
                address: viewModel.address,
                pictureID: viewModel.id,
                caption: viewModel.title,
                altText: viewModel.altText,
                tags: viewModel.tags
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview() {
        PictureView(
            viewModel: PictureViewModelMother.makePictureViewModel()
        )
        .frame(width: 200, height: 200)
    }

#endif
