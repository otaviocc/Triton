import DesignSystem
import Route
import SwiftUI

struct PasteView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private let viewModel: PasteViewModel

    // MARK: - Lifecycle

    init(
        viewModel: PasteViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            makeHeaderView()
            makeContentView()
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .card(.omgBackground)
        .onTapGesture(count: 2) {
            openEditor()
        }
        .contextMenu {
            makeContextualMenu()
        }
        .deleteConfirmation(isPresented: $showDeleteConfirmation) {
            viewModel.delete()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeHeaderView() -> some View {
        HStack(alignment: .center) {
            Text(viewModel.title)
            if !viewModel.isPublic {
                Image(systemName: "eye.slash")
            }
        }
        .textCase(.uppercase)
        .font(.caption)
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func makeContentView() -> some View {
        Text(viewModel.content)
            .monospaced()
            .truncationMode(.tail)
            .lineLimit(5)
            .foregroundColor(.primary)
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeEditPasteMenuItem()
        Divider()

        if viewModel.isPublic {
            makeCopyPasteURLMenuItem()
            makeCopyMarkdownLinkMenuItem()
            makeCopyMarkdownCodeBlockMenuItem()
            Divider()
            makeOpenInBrowserMenuItem()
            makeShareMenuItem()
            makeShareOnStatuslogMenuItem()
            Divider()
        }

        makeDeletePasteMenuItem()
    }

    @ViewBuilder
    private func makeEditPasteMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Paste", systemImage: "pencil")
        }
    }

    @ViewBuilder
    private func makeCopyPasteURLMenuItem() -> some View {
        Button {
            viewModel.copyPasteURLToClipboard()
        } label: {
            Label("Copy Paste URL", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopyMarkdownLinkMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownLinkToClipboard()
        } label: {
            Label("Copy as Markdown Link", systemImage: "doc.text")
        }
    }

    @ViewBuilder
    private func makeCopyMarkdownCodeBlockMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownCodeBlockToClipboard()
        } label: {
            Label("Copy as Markdown Code Block", systemImage: "apple.terminal")
        }
    }

    @ViewBuilder
    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(viewModel.permanentURL)
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    @ViewBuilder
    private func makeShareMenuItem() -> some View {
        ShareLink(item: viewModel.permanentURL) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }

    @ViewBuilder
    private func makeShareOnStatuslogMenuItem() -> some View {
        let url = viewModel.permanentURL.absoluteString
        let message = "Check out this: [\(viewModel.title)](\(url))"

        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: message
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
        }
    }

    @ViewBuilder
    private func makeDeletePasteMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete Paste", systemImage: "trash")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditPasteWindow.id,
            value: EditPaste(
                address: viewModel.address,
                title: viewModel.title,
                content: viewModel.content,
                isListed: viewModel.listed
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Listed") {
        PasteView(
            viewModel: PasteViewModelMother.makePasteViewModel()
        )
        .frame(width: 420)
    }

    #Preview("Unlisted") {
        PasteView(
            viewModel: PasteViewModelMother.makePasteViewModel(
                listed: false
            )
        )
        .frame(width: 420)
    }

#endif
