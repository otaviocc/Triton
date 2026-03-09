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

struct PURLView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private let viewModel: PURLViewModel

    // MARK: - Lifecycle

    init(
        viewModel: PURLViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            FaviconView(url: viewModel.originalURL)

            VStack(alignment: .leading, spacing: 4) {
                makeHeader()
                makeOriginalURLView()
                makePURLView()
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .card(.omgBackground)
        .contextMenu {
            makeContextualMenu()
        }
        .deleteConfirmation(isPresented: $showDeleteConfirmation) {
            viewModel.delete()
        }
    }

    // MARK: - Private

    private func makeHeader() -> some View {
        Text(viewModel.title)
            .textCase(.uppercase)
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private func makeOriginalURLView() -> some View {
        Text(viewModel.originalURL.absoluteString)
            .font(.title2)
            .truncationMode(.tail)
            .foregroundStyle(.primary)
    }

    private func makePURLView() -> some View {
        Text(viewModel.permanentURL.absoluteString)
            .font(.subheadline)
            .foregroundStyle(.accentColor)
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeCopyPURLMenuItem()
        makeCopyMarkdownLinkMenuItem()
        Divider()
        makeOpenInBrowserMenuItem()
        makeShareMenuItem()
        makeShareOnStatuslogMenuItem()
        Divider()
        makeDeletePURLMenuItem()
    }

    private func makeCopyPURLMenuItem() -> some View {
        Button {
            viewModel.copyPURLToClipboard()
        } label: {
            Label("Copy PURL", systemImage: "link")
        }
    }

    private func makeCopyMarkdownLinkMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownToClipboard()
        } label: {
            Label("Copy as Markdown URL", systemImage: "link")
        }
    }

    private func makeShareMenuItem() -> some View {
        ShareLink(item: viewModel.permanentURL) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }

    @ViewBuilder
    private func makeShareOnStatuslogMenuItem() -> some View {
        let url = viewModel.permanentURL.absoluteString
        let message = "Check out this: [\(url)](\(url))"

        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: message,
                    emoji: "🔗"
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
        }
    }

    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(viewModel.permanentURL)
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    private func makeDeletePURLMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete PURL", systemImage: "trash")
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        PURLView(
            viewModel: PURLViewModelMother.makePURLViewModel()
        )
        .frame(width: 420)
    }

#endif
