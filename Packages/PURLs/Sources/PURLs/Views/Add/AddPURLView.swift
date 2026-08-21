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

struct AddPURLView: View {

    // MARK: - Properties

    @State private var viewModel: AddPURLViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Lifecycle

    init(
        viewModel: AddPURLViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack(alignment: .leading) {
            makePURLNameView()
            makePURLView()
        }
        .toolbar(id: "purls.add") {
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
    private func makePURLNameView() -> some View {
        Text("Name")
        TextField("omg", text: $viewModel.name)
            .lineLimit(1)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Short name for permanent URL")
    }

    @ViewBuilder
    private func makePURLView() -> some View {
        Text("URL")
        TextField("https://omg.lol", text: $viewModel.urlString)
            .lineLimit(1)
            .font(.body.monospaced())
            .textFieldCard()
            .help("Destination URL for redirection")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some CustomizableToolbarContent {
        if viewModel.showAddressesPicker {
            ToolbarItem(
                id: "purls.add.address",
                placement: .automatic
            ) {
                AddressPickerToolbarItem(
                    addresses: viewModel.addresses,
                    selection: $viewModel.selectedAddress,
                    helpText: "Select address for PURL"
                )
            }
        }

        ToolbarItem(
            id: "purls.add.submit",
            placement: .automatic
        ) {
            makeCreatePURLToolbarItem()
        }
    }

    private func makeCreatePURLToolbarItem() -> some View {
        Button {
            viewModel.addPURL()
        } label: {
            Label(
                "Create",
                systemImage: viewModel.isSubmitDisabled ? "tray.and.arrow.down" : "tray.and.arrow.down.fill"
            )
        }
        .help("Create permanent URL")
        .keyboardShortcut(.return, modifiers: .command)
        .disabled(viewModel.isSubmitDisabled)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Empty") {
        AddPURLView(
            viewModel: AddPURLViewModelMother.makeAddPURLViewModel()
        )
        .frame(width: 420)
    }

    #Preview("With Name") {
        AddPURLView(
            viewModel: AddPURLViewModelMother.makeAddPURLViewModel(
                name: "omglol"
            )
        )
        .frame(width: 420)
    }

    #Preview("With URL") {
        AddPURLView(
            viewModel: AddPURLViewModelMother.makeAddPURLViewModel(
                urlString: "https://omg.lol"
            )
        )
        .frame(width: 420)
    }

    #Preview("All") {
        AddPURLView(
            viewModel: AddPURLViewModelMother.makeAddPURLViewModel(
                name: "omglol",
                urlString: "https://omg.lol"
            )
        )
        .frame(width: 420)
    }

#endif
