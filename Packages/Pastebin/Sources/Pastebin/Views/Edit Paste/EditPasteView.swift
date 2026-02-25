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
import SwiftUI

struct EditPasteView: View {

    // MARK: - Properties

    @State private var viewModel: EditPasteViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: EditPasteViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            makeEditorView()

            HStack {
                Spacer()
                Toggle("Listed?", isOn: $viewModel.isListed)
                    .help("Make paste publicly visible")
            }
        }
        .toolbar(id: "pastebin.edit") {
            makeToolbarContent()
        }
        .navigationTitle(viewModel.title)
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .padding()
    }

    // MARK: - Private

    private func makeEditorView() -> some View {
        TextEditor(text: $viewModel.content)
            .font(.body.monospaced())
            .disabled(viewModel.isSubmitDisabled)
            .textEditorCard()
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        if viewModel.isSubmitDisabled {
            ToolbarItem(
                id: "pastebin.edit.progress",
                placement: .automatic
            ) {
                ProgressToolbarItem()
            }
        }

        ToolbarItem(
            id: "pastebin.edit.submit",
            placement: .automatic
        ) {
            makePublishToolbarItem()
        }
    }

    private func makePublishToolbarItem() -> some View {
        Button {
            viewModel.publishPaste()
        } label: {
            Label("Save", systemImage: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Save changes to paste")
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - PreviewProvider

#if DEBUG

    #Preview(traits: .sizeThatFitsLayout) {
        EditPasteView(
            viewModel: EditPasteViewMother.makeEditPasteViewModel()
        )
    }

#endif
