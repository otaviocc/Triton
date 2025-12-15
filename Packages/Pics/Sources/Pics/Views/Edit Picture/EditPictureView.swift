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
        .frame(minWidth: 400, idealWidth: 640, maxWidth: 640)
        .toolbar {
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

    @ViewBuilder
    private func makeEditorView() -> some View {
        VStack {
            TextField("Caption", text: $viewModel.caption)
                .autocorrectionDisabled(false)
                .font(.body.monospaced())
                .textFieldCard()
                .help("Add a caption for your image")

            TextEditor(text: $viewModel.altText)
                .autocorrectionDisabled(false)
                .font(.body.monospaced())
                .textEditorCard()
                .help("Add descriptive alt text for accessibility")

            makeTagsView()
        }
    }

    @ViewBuilder
    private func makeTagsView() -> some View {
        VStack(alignment: .leading) {
            makeTagInputView()
            makeTagSuggestionsView()
            makeSelectedTagsView()
        }
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

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.shouldShowProgress {
                ProgressToolbarItem()
            }
            makeEditPictureToolbarItem()
        }
    }

    @ViewBuilder
    private func makeEditPictureToolbarItem() -> some View {
        Button {
            viewModel.updatePicture()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Update picture")
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
