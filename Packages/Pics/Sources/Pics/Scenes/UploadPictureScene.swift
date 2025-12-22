import Route
import SwiftUI

struct UploadPictureScene: Scene {

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
            UploadPictureWindow.name,
            id: UploadPictureWindow.id,
            for: UploadPicture.self
        ) { _ in
            makeUploadPictureView()
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .keyboardShortcut("p", modifiers: [.shift, .command])
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeUploadPictureView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeUploadViewModel()

        UploadView(
            viewModel: viewModel
        )
        .frame(minWidth: 640, idealWidth: 640, maxWidth: 800)
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }
}
