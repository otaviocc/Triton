import Route
import SwiftUI

struct EditNowPageScene: Scene {

    // MARK: - Properties

    private let environment: NowEnvironment

    // MARK: - Lifecycle

    init(
        environment: NowEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditNowPageWindow.name,
            id: EditNowPageWindow.id,
            for: EditNowPage.self
        ) { $status in
            makeEditorView(
                address: status?.address ?? "",
                content: status?.content ?? "",
                isListed: status?.isListed ?? false
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
        content: String,
        isListed: Bool
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditorViewModel(
                address: address,
                content: content,
                isListed: isListed
            )

        EditorView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
    }
}
