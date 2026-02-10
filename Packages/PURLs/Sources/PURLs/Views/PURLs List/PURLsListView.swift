import DesignSystem
import PURLsPersistenceService
import SwiftData
import SwiftUI

struct PURLsListView: View {

    // MARK: - Properties

    @State private var viewModel: PURLsListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var purls: [PURL]

    // MARK: - Lifecycle

    init(
        viewModel: PURLsListViewModel
    ) {
        self.viewModel = viewModel

        _purls = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if purls.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.purls)
            } else {
                makeListView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchPURLs()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(purls, id: \.id) { purl in
                    PURLContainer(purl: purl)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - PURLContainer

private struct PURLContainer: View {

    // MARK: - Properties

    let purl: PURL
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makePURLViewModel(purl: purl)
        PURLView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = PURLsRepositoryMother.makePURLsRepository()
        let environment = PURLsEnvironmentMother.makePURLsEnvironment()

        PURLsListView(
            viewModel: PURLsListViewModelMother.makePURLsListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.purlsContainer.mainContext)
        .frame(width: 420)
    }

    #Preview("With Content") {
        let repository = PURLsRepositoryMother.makePURLsRepository(count: 0)
        let environment = PURLsEnvironmentMother.makePURLsEnvironment()

        PURLsListView(
            viewModel: PURLsListViewModelMother.makePURLsListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.purlsContainer.mainContext)
        .frame(width: 420)
    }

#endif
