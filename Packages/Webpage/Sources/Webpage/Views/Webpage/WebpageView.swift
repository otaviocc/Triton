import DesignSystem
import Route
import SwiftUI

struct WebpageView: View {

    // MARK: - Properties

    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: WebpageViewModel

    // MARK: - Lifecycle

    init(
        viewModel: WebpageViewModel
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
            Label("Edit Web Page", systemImage: "pencil")
        }
    }

    @ViewBuilder
    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(URL(webpageFor: viewModel.address))
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditWebpageWindow.id,
            value: EditWebpage(
                address: viewModel.address,
                content: viewModel.markdown
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        WebpageView(
            viewModel: WebpageViewModelMother.makeWebpageViewModel()
        )
    }

#endif
