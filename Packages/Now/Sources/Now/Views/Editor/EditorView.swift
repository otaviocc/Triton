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
        .toolbar {
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

    @ViewBuilder
    private func makeEditorView() -> some View {
        TextEditor(text: $viewModel.content)
            .autocorrectionDisabled(false)
            .font(.body.monospaced())
            .textEditorCard()
            .disabled(viewModel.isSubmitDisabled)
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
            viewModel.publishNowPage()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Publish now page")
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
