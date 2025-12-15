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
        .toolbar {
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

    @ViewBuilder
    private func makeEditorView() -> some View {
        TextEditor(text: $viewModel.content)
            .font(.body.monospaced())
            .disabled(viewModel.isSubmitDisabled)
            .textEditorCard()
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.isSubmitDisabled {
                ProgressToolbarItem()
            }
            makePublishToolbarItem()
        }
    }

    @ViewBuilder
    private func makePublishToolbarItem() -> some View {
        Button {
            viewModel.publishPaste()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Save changes to paste")
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
