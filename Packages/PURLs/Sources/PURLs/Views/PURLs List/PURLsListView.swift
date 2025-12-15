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
        .onAppear {
            Task {
                try await viewModel.fetchPURLs()
            }
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(purls, id: \.self) { purl in
                    PURLView(
                        viewModel: viewModelFactory.makePURLViewModel(
                            purl: purl
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
