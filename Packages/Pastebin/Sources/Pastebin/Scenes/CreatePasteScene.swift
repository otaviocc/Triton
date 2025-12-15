import Route
import SwiftUI

struct CreatePasteScene: Scene {

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
            CreatePasteWindow.name,
            id: CreatePasteWindow.id,
            for: CreatePaste.self
        ) { _ in
            makeCreatePasteView()
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .keyboardShortcut("v", modifiers: [.shift, .command])
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeCreatePasteView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeCreatePasteViewModel()

        CreatePasteView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
    }
}
