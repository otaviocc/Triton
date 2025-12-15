import Route
import SwiftUI

struct EditPictureScene: Scene {

    // MARK: - Properties

    private let environment: PicsEnvironment

    // MARK: - Lifecycle

    init(
        environment: PicsEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditPictureWindow.name,
            id: EditPictureWindow.id,
            for: EditPicture.self
        ) { $status in
            makeEditorView(
                address: status?.address ?? "",
                pictureID: status?.pictureID ?? "",
                caption: status?.caption ?? "",
                altText: status?.altText ?? "",
                tags: status?.tags ?? []
            )
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .commandsRemoved()
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeEditorView(
        address: String,
        pictureID: String,
        caption: String,
        altText: String,
        tags: [String]
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditPictureViewModel(
                address: address,
                pictureID: pictureID,
                caption: caption,
                altText: altText,
                tags: tags
            )

        EditPictureView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
        .modelContainer(environment.modelContainer)
    }
}
