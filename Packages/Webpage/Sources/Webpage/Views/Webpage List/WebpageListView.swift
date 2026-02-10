import DesignSystem
import SwiftData
import SwiftUI
import WebpagePersistenceService

struct WebpageListView: View {

    // MARK: - Properties

    @State private var viewModel: WebpageListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var webpages: [Webpage]

    // MARK: - Lifecycle

    init(
        viewModel: WebpageListViewModel
    ) {
        self.viewModel = viewModel

        _webpages = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if webpages.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.webpage)
            } else {
                makeListView()
            }
        }
        .task {
            try? await viewModel.fetchWebpages()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(webpages, id: \.id) { webpage in
                    WebpageContainer(
                        webpage: webpage,
                        isCurrent: webpage == webpages.first
                    )
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct WebpageContainer: View {

    // MARK: - Properties

    let webpage: Webpage
    let isCurrent: Bool
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makeWebpageViewModel(
            webpage: webpage,
            isCurrent: isCurrent
        )

        WebpageView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = WebpageRepositoryMother.makeWebpageRepository()
        let environment = WebpageEnvironmentMother.makeWebpageEnvironment()

        WebpageListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.webpageContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = WebpageRepositoryMother.makeWebpageRepository(count: 0)
        let environment = WebpageEnvironmentMother.makeWebpageEnvironment()

        WebpageListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.webpageContainer.mainContext)
    }

#endif
