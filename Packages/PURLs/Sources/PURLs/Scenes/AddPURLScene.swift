import Route
import SwiftUI

struct AddPURLScene: Scene {

    // MARK: - Properties

    private let environment: PURLsEnvironment

    // MARK: - Lifecycle

    init(
        environment: PURLsEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            AddPURLWindow.name,
            id: AddPURLWindow.id,
            for: AddPURL.self
        ) { _ in
            makeAddPURLView()
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .keyboardShortcut("u", modifiers: [.shift, .command])
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makeAddPURLView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeAddPURLViewModel()

        AddPURLView(
            viewModel: viewModel
        )
        .frame(width: 420)
    }
}
