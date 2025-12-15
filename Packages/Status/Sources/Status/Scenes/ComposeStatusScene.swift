import Route
import SwiftUI

struct ComposeStatusScene: Scene {

    // MARK: - Properties

    private let environment: StatusEnvironment

    // MARK: - Lifecycle

    init(
        environment: StatusEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            ComposeWindow.name,
            id: ComposeWindow.id,
            for: ComposeStatus.self
        ) { $status in
            makePostStatusView(
                content: status?.message ?? "",
                emoji: status?.emoji ?? "💬"
            )
        }
        .windowResizability(.contentSize)
        #if os(macOS)
            .keyboardShortcut("s", modifiers: [.shift, .command])
            .defaultPosition(.center)
        #endif
    }

    // MARK: - Private

    @ViewBuilder
    private func makePostStatusView(
        content: String,
        emoji: String
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makePostStatusViewModel(
                content: content,
                emoji: emoji
            )

        PostStatusView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420)
    }
}
