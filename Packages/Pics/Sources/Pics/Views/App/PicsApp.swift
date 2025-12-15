import DesignSystem
import FoundationExtensions
import Route
import SessionServiceInterface
import SwiftUI

/// Main view for the Pics (Some Pics) feature.
///
/// `PicsApp` is the root view that displays the gallery of uploaded pictures
/// on the some.pics subdomain. It provides access to uploading new pictures,
/// editing picture metadata, and managing the image gallery.
struct PicsApp: View {

    // MARK: - Properties

    @State private var viewModel: PicsAppViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL

    // MARK: - Lifecycle

    init(
        viewModel: PicsAppViewModel
    ) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        makePicturesView()
    }

    // MARK: - Public

    @ViewBuilder
    private func makePicturesView() -> some View {
        switch viewModel.address {
        case .notSet:
            EmptyView()
        case let .address(current):
            makePicturesListView(
                address: current
            )
            .toolbar {
                makeToolbarContent(address: current)
            }
        }
    }

    @ViewBuilder
    private func makePicturesListView(
        address: SelectedAddress
    ) -> some View {
        PicturesListView(
            viewModel: viewModelFactory.makePicturesListViewModel(
                address: address
            )
        )
    }

    @ViewBuilder
    private func makeSomePicsToolbarItem(
        address: SelectedAddress
    ) -> some View {
        let weblogURL = URL(somePicsFor: address)

        Button {
            openURL(weblogURL)
        } label: {
            Image(systemName: "safari")
        }
        .help("Open Some Pics")
    }

    @ViewBuilder
    private func makeUploadPictureToolbarItem() -> some View {
        Button {
            openWindow(id: UploadPictureWindow.id)
        } label: {
            Image(systemName: "plus")
        }
        .help("Upload new picture")
    }

    @ToolbarContentBuilder
    private func makeToolbarContent(
        address: SelectedAddress
    ) -> some ToolbarContent {
        ToolbarItemGroup {
            makeSomePicsToolbarItem(address: address)
            RefreshToolbarItem(
                action: { viewModel.fetchPictures() },
                helpText: "Refresh pictures",
                isDisabled: viewModel.isLoading
            )
            makeUploadPictureToolbarItem()
        }
    }
}
