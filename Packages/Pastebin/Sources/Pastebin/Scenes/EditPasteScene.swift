import Route
import SwiftUI

struct EditPasteScene: Scene {

    // MARK: - Properties

    private let environment: PastebinEnvironment

    // MARK: - Lifecycle

    init(
        environment: PastebinEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditPasteWindow.name,
            id: EditPasteWindow.id,
            for: EditPaste.self
        ) { $status in
            makeEditorView(
                title: status?.title ?? "",
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
        title: String,
        address: String,
        content: String,
        isListed: Bool
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditorViewModel(
                address: address,
                title: title,
                content: content,
                isListed: isListed
            )

        EditPasteView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
    }
}
