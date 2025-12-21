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
        .toolbar {
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

    @ViewBuilder
    private func makeComposeView() -> some View {
        TextEditor(text: viewModel.isTextEditorDisabled ? .constant(viewModel.body) : $viewModel.body)
            .autocorrectionDisabled(false)
            .font(.body.monospaced())
            .textEditorCard()
    }

    @ViewBuilder
    private func makeSidebarView() -> some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
            GridRow(alignment: .firstTextBaseline) {
                Text("Date")
                    .gridColumnAlignment(.trailing)

                DatePicker(
                    selection: $viewModel.date,
                    displayedComponents: [.date]
                ) {}
                    .help("Select publication date")
            }

            GridRow(alignment: .firstTextBaseline) {
                Text("Time")
                    .gridColumnAlignment(.trailing)

                DatePicker(
                    selection: $viewModel.date,
                    displayedComponents: [.hourAndMinute]
                ) {}
                    .help("Select publication time")
            }

            GridRow(alignment: .firstTextBaseline) {
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
            }

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
    private func makeTagInputView() -> some View {
        TextField("Add tag", text: $viewModel.tagInput)
            .autocorrectionDisabled(true)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Enter a tag and press the return key to add it")
            .onSubmit {
                withAnimation {
                    viewModel.addTag(viewModel.tagInput)
                }
            }
            .onChange(of: viewModel.tagInput) {
                viewModel.updateTagSuggestions(from: existingTags.map(\.title))
            }
    }

    @ViewBuilder
    private func makeTagSuggestionsView() -> some View {
        if !viewModel.suggestedTags.isEmpty {
            TagListView(
                tags: viewModel.suggestedTags,
                helpText: { "Add existing tag '\($0)'" }
            ) { tag in
                withAnimation {
                    viewModel.addTag(tag)
                }
            }
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
                helpText: { "Remove tag '\($0)'" }
            ) { tag in
                withAnimation {
                    viewModel.removeTag(tag)
                }
            }
        }
    }

    @ViewBuilder
    private func makePublishToolbarItem() -> some View {
        Button {
            viewModel.publishWeblogEntry()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Publish weblog entry")
        .disabled(viewModel.isSubmitDisabled)
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.shouldShowProgress {
                ProgressToolbarItem()
            }
            makePublishToolbarItem()
        }
    }
}

// MARK: - PreviewProvider

#if DEBUG

    #Preview(traits: .sizeThatFitsLayout) {
        EditorView(
            viewModel: EditorViewModelMother.makeEditorViewModel()
        )
    }

#endif
