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
                status: entry?.status.flatMap(WeblogEntryStatus.init) ?? .draft,
                tags: entry?.tags ?? .init(),
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
        status: WeblogEntryStatus,
        tags: [String],
        address: String
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeEditWeblogEntryViewModel(
                address: address,
                body: body,
                date: date,
                entryID: entryID,
                status: status,
                tags: tags
            )

        EditorView(
            viewModel: viewModel
        )
        .modelContainer(environment.modelContainer)
        .frame(minWidth: 640, idealWidth: 640, maxWidth: 800)
    }
}
