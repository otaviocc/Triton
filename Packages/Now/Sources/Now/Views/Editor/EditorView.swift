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

struct EditorView: View {

    // MARK: - Properties

    @State private var viewModel: EditorViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: EditorViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            makeEditorView()

            HStack {
                Spacer()
                Toggle("Add to Garden", isOn: $viewModel.isListed)
                    .help("Include in public garden listing")
            }
        }
        .toolbar(id: "now.editor") {
            makeToolbarContent()
        }
        .navigationTitle(viewModel.viewTitle)
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
            .autocorrectionDisabled(false)
            .font(.body.monospaced())
            .textEditorCard()
            .disabled(viewModel.isSubmitDisabled)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        if viewModel.isSubmitDisabled {
            ToolbarItem(
                id: "now.editor.progress",
                placement: .automatic
            ) {
                ProgressToolbarItem()
            }
        }
        
        ToolbarItem(
            id: "now.editor.publish",
            placement: .automatic
        ) {
            makePublishToolbarItem()
        }
    }

    private func makePublishToolbarItem() -> some View {
        Button {
            viewModel.publishNowPage()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Publish now page")
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - PreviewProvider

#if DEBUG

    #Preview(traits: .sizeThatFitsLayout) {
        EditorView(
            viewModel: EditorViewMother.makeEditorViewModel()
        )
    }

#endif
