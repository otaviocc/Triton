import DesignSystem
import Route
import SwiftUI

struct NowView: View {

    // MARK: - Properties

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: NowViewModel

    // MARK: - Lifecycle

    init(
        viewModel: NowViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack {
            Text(viewModel.publishedDate)

            if viewModel.isCurrent {
                Spacer()
                Text("Published")
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(.omgBackground)
        .onTapGesture(count: 2) {
            openEditor()
        }
        .contextMenu {
            makeContextualMenu()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeOpenEditorMenuItem()
        if viewModel.isCurrent {
            makeOpenInBrowserMenuItem()
        }
    }

    @ViewBuilder
    private func makeOpenEditorMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Now Page", systemImage: "pencil")
        }
    }

    @ViewBuilder
    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(URL(nowPageFor: viewModel.address))
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditNowPageWindow.id,
            value: EditNowPage(
                address: viewModel.address,
                content: viewModel.markdown,
                isListed: viewModel.listed
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        NowView(
            viewModel: NowViewModelMother.makeNowViewModel()
        )
    }

#endif
