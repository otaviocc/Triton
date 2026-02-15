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

struct WebpageView: View {

    // MARK: - Properties

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: WebpageViewModel

    // MARK: - Lifecycle

    init(
        viewModel: WebpageViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack {
            Text(viewModel.publishedDate)

            if viewModel.isCurrent {
                Spacer()
                Text("Published")
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(.omgBackground)
        .onTapGesture(count: 2) {
            openEditor()
        }
        .contextMenu {
            makeContextualMenu()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeOpenEditorMenuItem()
        if viewModel.isCurrent {
            makeOpenInBrowserMenuItem()
        }
    }

    private func makeOpenEditorMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Web Page", systemImage: "pencil")
        }
    }

    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(URL(webpageFor: viewModel.address))
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditWebpageWindow.id,
            value: EditWebpage(
                address: viewModel.address,
                content: viewModel.markdown
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        WebpageView(
            viewModel: WebpageViewModelMother.makeWebpageViewModel()
        )
    }

#endif
