import DesignSystem
import Route
import SwiftUI

struct WeblogEntryView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: WeblogEntryViewModel

    // MARK: - Lifecycle

    init(
        viewModel: WeblogEntryViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            makeHeaderView()
            makeContentView()

            if viewModel.showStatus {
                makeStatusView()
            }
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
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: "clock")

            Text(viewModel.formattedDate)
                .textCase(.uppercase)
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func makeContentView() -> some View {
        Text(viewModel.title)
            .truncationMode(.tail)
            .lineLimit(2)
            .foregroundColor(.primary)
    }

    @ViewBuilder
    private func makeStatusView() -> some View {
        HStack {
            Spacer()
            Text(viewModel.status)
                .textCase(.uppercase)
                .font(.caption)
                .foregroundColor(.accentColor)
        }
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeEditEntryMenuItem()
        Divider()
        makeCopyEntryURLMenuItem()
        makeCopyMarkdownLinkMenuItem()
        Divider()
        makeOpenInBrowserMenuItem()
        makeShareMenuItem()
        makeShareOnStatuslogMenuItem()
        Divider()
        makeDeleteEntryMenuItem()
    }

    @ViewBuilder
    private func makeEditEntryMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Entry", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopyEntryURLMenuItem() -> some View {
        Button {
            viewModel.copyEntryURLToClipboard()
        } label: {
            Label("Copy Entry URL", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopyMarkdownLinkMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownLinkToClipboard()
        } label: {
            Label("Copy as Markdown Link", systemImage: "link")
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
        let message = "Check out my blog post: [\(viewModel.title)](\(url))"

        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: message,
                    emoji: "📝"
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
        }
    }

    @ViewBuilder
    private func makeDeleteEntryMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete Entry", systemImage: "trash")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditWeblogEntryWindow.id,
            value: EditWeblogEntry(
                address: viewModel.address,
                body: viewModel.body,
                date: viewModel.publishedDate,
                entryID: viewModel.id
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("Is Draft") {
        WeblogEntryView(
            viewModel: WeblogEntryViewModelMother.makeWeblogEntryViewModel(
                isDraft: true
            )
        )
        .frame(width: 420)
    }

    #Preview("Is Published") {
        WeblogEntryView(
            viewModel: WeblogEntryViewModelMother.makeWeblogEntryViewModel(
                isDraft: false
            )
        )
        .frame(width: 420)
    }

#endif
