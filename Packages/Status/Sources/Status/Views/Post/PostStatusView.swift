import DesignSystem
import SwiftUI

struct PostStatusView: View {

    // MARK: - Properties

    @State private var isPopoverPresented = false
    @State private var viewModel: PostStatusViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: PostStatusViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                makeEmojiView()
                makeEditorView()
            }
            makeStatusView()
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
    private func makeEmojiView() -> some View {
        Text(viewModel.emoji)
            .font(.system(size: 56))
            .frame(width: 60, height: 60)
            .help("Select emoji")
            .onTapGesture {
                isPopoverPresented = true
            }
            .popover(
                isPresented: $isPopoverPresented,
                arrowEdge: .bottom
            ) {
                makeEmojiPickerView()
            }
    }

    @ViewBuilder
    private func makeEditorView() -> some View {
        TextEditor(text: $viewModel.content)
            .autocorrectionDisabled(false)
            .frame(minHeight: 60, idealHeight: 60)
            .font(.body.monospaced())
            .textEditorCard()
    }

    @ViewBuilder
    private func makeStatusView() -> some View {
        HStack {
            Spacer()

            Text(viewModel.status)
                .monospacedDigit()
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.showAddressesPicker {
                AddressPickerToolbarItem(
                    addresses: viewModel.addresses,
                    selection: $viewModel.selectedAddress,
                    helpText: "Select posting address"
                )
            }
            makePostStatusUpdateToolbarItem()
        }
    }

    @ViewBuilder
    private func makePostStatusUpdateToolbarItem() -> some View {
        Button {
            viewModel.postStatus()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Post status update")
        .disabled(viewModel.isSubmitDisabled)
    }

    @ViewBuilder
    private func makeEmojiPickerView() -> some View {
        EmojiPickerView(
            binding: $viewModel.emoji,
            isPresented: $isPopoverPresented
        )
        .frame(width: 300, height: 300)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        PostStatusView(
            viewModel: PostStatusViewModelMother.makePostStatusViewModel()
        )
        .frame(width: 420)
    }

    #Preview("Larger View") {
        PostStatusView(
            viewModel: PostStatusViewModelMother.makePostStatusViewModel()
        )
        .frame(width: 800, height: 600)
    }

#endif
