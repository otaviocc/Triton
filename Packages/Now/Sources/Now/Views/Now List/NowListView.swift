import DesignSystem
import NowPersistenceService
import SwiftData
import SwiftUI

struct NowListView: View {

    // MARK: - Properties

    @State private var viewModel: NowListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var nowPages: [Now]

    // MARK: - Lifecycle

    init(
        viewModel: NowListViewModel
    ) {
        self.viewModel = viewModel

        _nowPages = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if nowPages.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.nowPage)
            } else {
                makeListView()
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                try await viewModel.fetchNowPage()
            }
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(nowPages, id: \.self) { nowPage in
                    NowView(
                        viewModel: viewModelFactory.makeNowViewModel(
                            nowPage: nowPage,
                            isCurrent: nowPage == nowPages.first
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
        let repository = NowRepositoryMother.makeNowRepository()
        let environment = NowEnvironmentMother.makeNowEnvironment()

        NowListView(
            viewModel: .init(
                address: "otaviocc",
                repository: NowRepositoryMother.makeNowRepository()
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.nowContainer)
    }

    #Preview("Without Content") {
        let repository = NowRepositoryMother.makeNowRepository(count: 0)
        let environment = NowEnvironmentMother.makeNowEnvironment()

        NowListView(
            viewModel: .init(
                address: "otaviocc",
                repository: NowRepositoryMother.makeNowRepository()
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.nowContainer)
    }

#endif
