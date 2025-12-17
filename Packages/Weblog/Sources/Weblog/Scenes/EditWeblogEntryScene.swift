import Route
import SwiftUI

struct EditWeblogEntryScene: Scene {

    // MARK: - Properties

    private let environment: WeblogEnvironment

    // MARK: - Lifecycle

    init(
        environment: WeblogEnvironment
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            EditWeblogEntryWindow.name,
            id: EditWeblogEntryWindow.id,
            for: EditWeblogEntry.self
        ) { $entry in
            makeEditorView(
                body: entry?.body ?? "",
                date: entry?.date ?? .init(),
                entryID: entry?.entryID,
                address: entry?.address ?? ""
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
        body: String,
        date: Date,
        entryID: String?,
        address: String
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditWeblogEntryViewModel(
                address: address,
                body: body,
                date: date,
                entryID: entryID
            )

        EditorView(
            viewModel: viewModel
        )
        .frame(minWidth: 420, idealWidth: 420, maxWidth: 640)
    }
}
