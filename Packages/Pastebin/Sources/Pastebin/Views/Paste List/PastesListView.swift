import DesignSystem
import PastebinPersistenceService
import SwiftData
import SwiftUI

struct PastesListView: View {

    // MARK: - Properties

    @State private var viewModel: PastesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var pastes: [Paste]

    // MARK: - Lifecycle

    init(
        viewModel: PastesListViewModel
    ) {
        self.viewModel = viewModel

        _pastes = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if pastes.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.pastebin)
            } else {
                makeListView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchPastes()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(pastes, id: \.id) { paste in
                    PasteContainer(paste: paste)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - PasteContainer

private struct PasteContainer: View {

    // MARK: - Properties

    let paste: Paste
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makePasteViewModel(paste: paste)
        PasteView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = PastebinRepositoryMother.makePastebinRepository()
        let environment = PastebinEnvironmentMother.makePastebinEnvironment()

        PastesListView(
            viewModel: PastesListViewModelMother.makePastesListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.pastebinContainer)
        .frame(width: 420)
    }

    #Preview("Without Content") {
        let repository = PastebinRepositoryMother.makePastebinRepository(count: 0)
        let environment = PastebinEnvironmentMother.makePastebinEnvironment()

        PastesListView(
            viewModel: PastesListViewModelMother.makePastesListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.pastebinContainer)
        .frame(width: 420)
    }

#endif
