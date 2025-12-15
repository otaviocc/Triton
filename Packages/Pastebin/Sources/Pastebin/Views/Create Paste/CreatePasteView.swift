import DesignSystem
import SwiftUI

struct CreatePasteView: View {

    // MARK: - Properties

    @State private var viewModel: CreatePasteViewModel
    @State private var isPopoverPresented = false
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: CreatePasteViewModel
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
                    .help("Make paste publicly visible in directory")
            }
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
    private func makeEditorView() -> some View {
        VStack {
            TextField("Filename", text: $viewModel.title)
                .font(.body.monospaced())
                .textFieldCard()
                .help("Optional filename")

            TextEditor(text: $viewModel.content)
                .font(.body.monospaced())
                .textEditorCard()
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.showAddressesPicker {
                AddressPickerToolbarItem(
                    addresses: viewModel.addresses,
                    selection: $viewModel.selectedAddress,
                    helpText: "Select address for paste"
                )
            }
            makeCreatePasteToolbarItem()
        }
    }

    @ViewBuilder
    private func makeCreatePasteToolbarItem() -> some View {
        Button {
            viewModel.postPaste()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Create paste")
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - PreviewProvider

#if DEBUG

    #Preview(traits: .sizeThatFitsLayout) {
        CreatePasteView(
            viewModel: CreatePasteViewMother.makeCreatePasteViewModel()
        )
    }

#endif
