import DesignSystem
import SwiftData
import SwiftUI
import WeblogPersistenceService

struct WeblogEntriesListView: View {

    // MARK: - Properties

    @State private var viewModel: WeblogEntriesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var entries: [WeblogEntry]

    // MARK: - Lifecycle

    init(
        viewModel: WeblogEntriesListViewModel
    ) {
        self.viewModel = viewModel

        _entries = .init(viewModel.fetchDescriptor())
    }

    // MARK; - Public

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.weblog)
            } else {
                makeEntriesView()
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                try await viewModel.fetchWeblogEntries()
            }
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeEntriesView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(entries, id: \.self) { entry in
                    WeblogEntryView(
                        viewModel: viewModelFactory.makeWeblogEntryViewModel(
                            entry: entry
                        )
                    )
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content (Date Descending)") {
        let repository = WeblogRepositoryMother.makeWeblogRepository()
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateDescending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

    #Preview("With Content (Date Ascending)") {
        let repository = WeblogRepositoryMother.makeWeblogRepository()
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateAscending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = WeblogRepositoryMother.makeWeblogRepository(count: 0)
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateAscending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

#endif
