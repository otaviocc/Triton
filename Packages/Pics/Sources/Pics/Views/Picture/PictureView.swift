import DesignSystem
import Route
import SwiftUI

struct PictureView: View {

    // MARK: - Properties

    @State private var showDeleteConfirmation = false
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    private var viewModel: PictureViewModel

    // MARK: - Lifecycle

    init(
        viewModel: PictureViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makePictureView()
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
    private func makePictureView() -> some View {
        GeometryReader { geometry in
            AsyncImage(url: viewModel.photoURL?.imagePreviewURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.width
            )
            .clipped()
            .clipShape(.rect(cornerRadius: 8))
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func makeContextualMenu() -> some View {
        makeEditPictureMenuItem()
        Divider()
        makeCopyPhotoURLMenuItem()
        makeCopySomePicsURLMenuItem()
        makeCopyMarkdownLinkMenuItem()
        makeCopyMarkdownImageMenuItem()
        Divider()
        makeOpenInBrowserMenuItem()
        makeShareMenuItem()
        makeShareOnStatuslogMenuItem()
        Divider()
        makeDeletePictureMenuItem()
    }

    @ViewBuilder
    private func makeEditPictureMenuItem() -> some View {
        Button {
            openEditor()
        } label: {
            Label("Edit Picture Description", systemImage: "pencil")
        }
    }

    @ViewBuilder
    private func makeCopyPhotoURLMenuItem() -> some View {
        Button {
            viewModel.copyPhotoURLToClipboard()
        } label: {
            Label("Copy Picture URL", systemImage: "link")
        }
    }

    @ViewBuilder
    private func makeCopySomePicsURLMenuItem() -> some View {
        Button {
            viewModel.copySomePicsURLToClipboard()
        } label: {
            Label("Copy Some Pics URL", systemImage: "link")
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
    private func makeCopyMarkdownImageMenuItem() -> some View {
        Button {
            viewModel.copyMarkdownImageToClipboard()
        } label: {
            Label("Copy as Markdown Image", systemImage: "photo")
        }
    }

    @ViewBuilder
    private func makeOpenInBrowserMenuItem() -> some View {
        Button {
            openURL(viewModel.somePicsURL!)
        } label: {
            Label("Open in Browser", systemImage: "safari")
        }
    }

    @ViewBuilder
    private func makeShareMenuItem() -> some View {
        if let somePicsURL = viewModel.somePicsURL {
            ShareLink(item: somePicsURL) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }

    @ViewBuilder
    private func makeShareOnStatuslogMenuItem() -> some View {
        Button {
            openWindow(
                id: ComposeWindow.id,
                value: ComposeStatus(
                    message: viewModel.markdownLink ?? "",
                    emoji: "📷"
                )
            )
        } label: {
            Label("Share on Statuslog", systemImage: "message")
        }
    }

    @ViewBuilder
    private func makeDeletePictureMenuItem() -> some View {
        Button {
            showDeleteConfirmation = true
        } label: {
            Label("Delete Picture", systemImage: "trash")
        }
    }

    private func openEditor() {
        openWindow(
            id: EditPictureWindow.id,
            value: EditPicture(
                address: viewModel.address,
                pictureID: viewModel.id,
                caption: viewModel.title,
                altText: viewModel.altText,
                tags: viewModel.tags
            )
        )
    }
}

// MARK: - Preview

#if DEBUG

    #Preview() {
        PictureView(
            viewModel: PictureViewModelMother.makePictureViewModel()
        )
        .frame(width: 200, height: 200)
    }

#endif
