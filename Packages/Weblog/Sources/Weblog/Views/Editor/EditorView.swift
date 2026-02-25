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
import SwiftData
import SwiftUI
import WeblogPersistenceService

struct EditorView: View {

    // MARK: - Properties

    @State private var viewModel: EditorViewModel
    @Environment(\.dismiss) private var dismiss
    @Query(WeblogTag.fetchDescriptor()) private var existingTags: [WeblogTag]

    // MARK: - Computed Properties

    private var existingTagTitles: [String] {
        existingTags.map(\.title)
    }

    // MARK: - Lifecycle

    init(
        viewModel: EditorViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                makeComposeView()
                makeSidebarView()
            }
            makeSelectedTagsView()
        }
        .toolbar(id: "weblog.editor") {
            makeToolbarContent()
        }
        .navigationTitle("")
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .padding()
    }

    // MARK: - Private

    private func makeComposeView() -> some View {
        TextEditor(text: $viewModel.body)
            .disabled(viewModel.isTextEditorDisabled)
            .autocorrectionDisabled(false)
            .font(.body.monospaced())
            .textEditorCard()
    }

    private func makeSidebarView() -> some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
            GridRow(alignment: .firstTextBaseline) {
                makeDatePicker()
            }

            GridRow(alignment: .firstTextBaseline) {
                makeTimePicker()
            }

            Divider()
                .foregroundStyle(Color.accentColor)

            GridRow(alignment: .firstTextBaseline) {
                makeStatusPicker()
            }

            Divider()
                .foregroundStyle(Color.accentColor)

            GridRow(alignment: .firstTextBaseline) {
                Text("Tags")
                    .gridColumnAlignment(.trailing)

                VStack {
                    makeTagInputView()
                    makeTagSuggestionsView()
                    makeTagInputDescription()
                }
            }
        }
        .frame(width: 200)
        .padding()
    }

    @ViewBuilder
    private func makeDatePicker() -> some View {
        Text("Date")
            .gridColumnAlignment(.trailing)

        DatePicker(
            selection: $viewModel.date,
            displayedComponents: [.date]
        ) {}
            .help("Select publication date")
    }

    @ViewBuilder
    private func makeTimePicker() -> some View {
        Text("Time")
            .gridColumnAlignment(.trailing)

        DatePicker(
            selection: $viewModel.date,
            displayedComponents: [.hourAndMinute]
        ) {}
            .help("Select publication time")
    }

    @ViewBuilder
    private func makeStatusPicker() -> some View {
        Text("Status")
            .gridColumnAlignment(.trailing)

        Picker(
            selection: $viewModel.status,
            content: {
                ForEach(WeblogEntryStatus.allCases) { status in
                    Text(status.displayName)
                }
            },
            label: { EmptyView() }
        )
        .pickerStyle(.radioGroup)
        .labelsHidden()
        .help("Select publication visibility")
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
    private func makeTagInputDescription() -> some View {
        if viewModel.suggestedTags.isEmpty {
            Text("Type a tag and press Return")
                .font(.footnote)
                .foregroundStyle(.secondary)
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

    private func makePublishToolbarItem() -> some View {
        Button {
            viewModel.publishWeblogEntry()
        } label: {
            Label("Publish", systemImage: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Publish weblog entry")
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(viewModel.isSubmitDisabled)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        if viewModel.shouldShowProgress {
            ToolbarItem(
                id: "weblog.editor.progress",
                placement: .automatic
            ) {
                ProgressToolbarItem()
            }
        }

        ToolbarItem(
            id: "weblog.editor.publish",
            placement: .automatic
        ) {
            makePublishToolbarItem()
        }
    }
}

// MARK: - PreviewProvider

#if DEBUG

    #Preview("Draft", traits: .sizeThatFitsLayout) {
        EditorView(
            viewModel: EditorViewModelMother.makeEditorViewModel()
        )
    }

    #Preview("Live with Tags", traits: .sizeThatFitsLayout) {
        EditorView(
            viewModel: EditorViewModelMother.makeEditorViewModel(
                status: .live,
                tags: ["Foo", "Bar"]
            )
        )
    }

#endif
