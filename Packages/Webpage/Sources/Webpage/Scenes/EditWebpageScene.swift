import Route
import SwiftUI

struct EditWebpageScene: Scene {

    // MARK: - Properties

    private let environment: WebpageEnvironment

    // MARK: - Lifecycle

    init(
        environment: WebpageEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditWebpageWindow.name,
            id: EditWebpageWindow.id,
            for: EditWebpage.self
        ) { $status in
            makeEditorView(
                address: status?.address ?? "",
                content: status?.content ?? ""
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
        content: String
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditorViewModel(
                address: address,
                content: content
            )

        EditorView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
    }
}
