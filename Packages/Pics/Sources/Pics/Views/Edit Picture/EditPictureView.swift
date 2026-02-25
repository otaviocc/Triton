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
import PicsPersistenceService
import SwiftData
import SwiftUI

struct EditPictureView: View {

    // MARK: - Properties

    @State private var viewModel: EditPictureViewModel
    @Environment(\.dismiss) private var dismiss
    @Query(SomeTag.fetchDescriptor()) private var existingTags: [SomeTag]

    // MARK: - Computed Properties

    private var existingTagTitles: [String] {
        existingTags.map(\.title)
    }

    // MARK: - Lifecycle

    init(
        viewModel: EditPictureViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            makeEditorView()
        }
        .toolbar(id: "pics.edit") {
            makeToolbarContent()
        }
        .navigationTitle("Pics")
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .padding()
    }

    // MARK: - Private

    private func makeEditorView() -> some View {
        VStack {
            PlaceholderTextEditor(
                placeholder: "Caption",
                text: $viewModel.caption,
                help: "Add a caption for your image"
            )

            PlaceholderTextEditor(
                placeholder: "Alt text",
                text: $viewModel.altText,
                help: "Add descriptive alt text for accessibility"
            )

            makeTagsView()
        }
    }

    private func makeTagsView() -> some View {
        VStack(alignment: .leading) {
            makeTagInputView()
            makeTagSuggestionsView()
            makeSelectedTagsView()
        }
    }

    private func makeTagInputView() -> some View {
        TextField("Add tag", text: $viewModel.tagInput)
            .autocorrectionDisabled(true)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Enter a tag and press the return key to add it, or press tab to select the first suggestion")
            .onSubmit {
                withAnimation {
                    viewModel.addTag(viewModel.tagInput)
                }
            }
            .onChange(of: viewModel.tagInput) {
                viewModel.updateTagSuggestions(from: existingTagTitles)
            }
            .onKeyPress(.tab) {
                do {
                    try viewModel.selectFirstTagSuggestion()
                    return .handled
                } catch {
                    return .ignored
                }
            }
    }

    @ViewBuilder
    private func makeTagSuggestionsView() -> some View {
        if !viewModel.suggestedTags.isEmpty {
            TagListView(
                tags: viewModel.suggestedTags,
                helpText: { "Add existing tag '\($0)'" },
                action: { tag in
                    withAnimation {
                        viewModel.addTag(tag)
                    }
                }
            )
        }
    }

    @ViewBuilder
    private func makeSelectedTagsView() -> some View {
        if !viewModel.tags.isEmpty {
            TagListView(
                tags: viewModel.tags,
                style: .remove,
                helpText: { "Remove tag '\($0)'" },
                action: { tag in
                    withAnimation {
                        viewModel.removeTag(tag)
                    }
                }
            )
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        if viewModel.shouldShowProgress {
            ToolbarItem(
                id: "pics.edit.progress",
                placement: .automatic
            ) {
                ProgressToolbarItem()
            }
        }

        ToolbarItem(
            id: "pics.edit.submit",
            placement: .automatic
        ) {
            makeEditPictureToolbarItem()
        }
    }

    private func makeEditPictureToolbarItem() -> some View {
        Button {
            viewModel.updatePicture()
        } label: {
            Label("Update", systemImage: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Update picture")
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Without Data") {
        EditPictureView(
            viewModel: EditPictureViewModelMother.makeEditPictureViewModel()
        )
    }

    #Preview("With Data") {
        EditPictureView(
            viewModel: EditPictureViewModelMother.makeEditPictureViewModel(
                caption: "This is the photo caption",
                altText: "This is a very long alt text for the image, describing the image.",
                tags: ["foo", "bar"],
                isHidden: false
            )
        )
    }

#endif
