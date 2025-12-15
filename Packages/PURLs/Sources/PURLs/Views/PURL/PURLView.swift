import DesignSystem
import Route
import SwiftUI

struct PURLView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private let viewModel: PURLViewModel

    // MARK: - Lifecycle

    init(
        viewModel: PURLViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            FaviconView(url: viewModel.originalURL)

            VStack(alignment: .leading, spacing: 4) {
                makeHeader()
                makeOriginalURLView()
                makePURLView()
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .card(.omgBackground)
        .contextMenu {
            makeContextualMenu()
        }
        .deleteConfirmation(isPresented: $showDeleteConfirmation) {
            viewModel.delete()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeHeader() -> some View {
        Text(viewModel.title)
            .textCase(.uppercase)
            .font(.caption)
            .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func makeOriginalURLView() -> some View {
        Text(viewModel.originalURL.absoluteString)
            .font(.title2)
            .truncationMode(.tail)
            .foregroundColor(.primary)
    }

    @ViewBuilder
    private func makePURLView() -> some View {
        Text(viewModel.permanentURL.absoluteString)
            .font(.subheadline)
            .foregroundColor(.accentColor)
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeCopyPURLMenuItem()
        makeCopyMarkdownLinkMenuItem()
        Divider()
        makeOpenInBrowserMenuItem()
        makeShareMenuItem()
        makeShareOnStatuslogMenuItem()
        Divider()
        makeDeletePURLMenuItem()
    }

    @ViewBuilder
    private func makeCopyPURLMenuItem() -> some View {
        Button {
            viewModel.copyPURLToClipboard()
        } label: {
            Label("Copy PURL", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopyMarkdownLinkMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownToClipboard()
        } label: {
            Label("Copy as Markdown URL", systemImage: "link")
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
        let message = "Check out this: [\(url)](\(url))"

        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: message,
                    emoji: "🔗"
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
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
    private func makeDeletePURLMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete PURL", systemImage: "trash")
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        PURLView(
            viewModel: PURLViewModelMother.makePURLViewModel()
        )
        .frame(width: 420)
    }

#endif
