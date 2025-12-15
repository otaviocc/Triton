import DesignSystem
import SwiftUI

struct EditorView: View {

    // MARK: - Properties

    @State private var viewModel: EditorViewModel
    @State private var isPopoverPresented = false
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: EditorViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .top) {
            makeComposeView()
            makeSidebarView()
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
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
            GridRow {
                Text("Date")
                    .gridColumnAlignment(.trailing)

                DatePicker(
                    selection: $viewModel.date,
                    displayedComponents: [.date]
                ) {}
                    .help("Select publication date")
            }

            GridRow {
                Text("Time")
                    .gridColumnAlignment(.trailing)

                DatePicker(
                    selection: $viewModel.date,
                    displayedComponents: [.hourAndMinute]
                ) {}
                    .help("Select publication time")
            }
        }
        .padding()
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
