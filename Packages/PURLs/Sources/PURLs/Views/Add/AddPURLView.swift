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
    private func makePURLNameView() -> some View {
        Group {
            Text("Name")
            TextField("omg", text: $viewModel.name)
                .lineLimit(1)
                .font(.body.monospaced())
                .textFieldCard()
                .help("Short name for permanent URL")
        }
    }

    @ViewBuilder
    private func makePURLView() -> some View {
        Group {
            Text("URL")
            TextField("https://omg.lol", text: $viewModel.urlString)
                .lineLimit(1)
                .font(.body.monospaced())
                .textFieldCard()
                .help("Destination URL for redirection")
        }
    }

    @ToolbarContentBuilder
    private func makeToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup {
            if viewModel.showAddressesPicker {
                AddressPickerToolbarItem(
                    addresses: viewModel.addresses,
                    selection: $viewModel.selectedAddress,
                    helpText: "Select address for PURL"
                )
            }
            makeCreatePURLToolbarItem()
        }
    }

    @ViewBuilder
    private func makeCreatePURLToolbarItem() -> some View {
        Button {
            viewModel.addPURL()
        } label: {
            Image(systemName: viewModel.isSubmitDisabled ? "tray.and.arrow.down" : "tray.and.arrow.down.fill")
        }
        .help("Create permanent URL")
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
