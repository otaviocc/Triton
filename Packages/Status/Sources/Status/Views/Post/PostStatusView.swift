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

    private func makeEditorView() -> some View {
        TextEditor(text: $viewModel.content)
            .autocorrectionDisabled(false)
            .frame(minHeight: 60, idealHeight: 60)
            .font(.body.monospaced())
            .textEditorCard()
    }

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

    private func makePostStatusUpdateToolbarItem() -> some View {
        Button {
            viewModel.postStatus()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "paperplane" : "paperplane.fill")
        }
        .help("Post status update")
        .disabled(viewModel.isSubmitDisabled)
    }

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
