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

struct NowView: View {

    // MARK: - Properties

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: NowViewModel

    // MARK: - Lifecycle

    init(
        viewModel: NowViewModel
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
                    .foregroundStyle(.accentColor)
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
            Label("Edit Now Page", systemImage: "pencil")
        }
    }

    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(URL(nowPageFor: viewModel.address))
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditNowPageWindow.id,
            value: EditNowPage(
                address: viewModel.address,
                content: viewModel.markdown,
                isListed: viewModel.listed
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        NowView(
            viewModel: NowViewModelMother.makeNowViewModel()
        )
    }

#endif
