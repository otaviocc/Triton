import DesignSystem
import PicsPersistenceService
import SwiftData
import SwiftUI

struct PicturesListView: View {

    // MARK: - Properties

    @State private var viewModel: PicturesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var pictures: [SomePicture]

    // MARK: - Lifecycle

    init(
        viewModel: PicturesListViewModel
    ) {
        self.viewModel = viewModel

        _pictures = .init(viewModel.fetchDescriptor())
    }

    // MARK; - Public

    var body: some View {
        Group {
            if pictures.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.somePics)
            } else {
                makePicturesView()
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                try await viewModel.fetchPictures()
            }
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makePicturesView() -> some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 200))
            ]) {
                ForEach(pictures, id: \.self) { picture in
                    PictureView(
                        viewModel: viewModelFactory.makePictureViewModel(
                            picture: picture
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
        let repository = PicsRepositoryMother.makePicsRepository()
        let environment = PicsEnvironmentMother.makePicsEnvironment()

        PicturesListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .frame(width: 500, height: 500)
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.picturesContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = PicsRepositoryMother.makePicsRepository(count: 0)
        let environment = PicsEnvironmentMother.makePicsEnvironment()

        PicturesListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .frame(width: 500, height: 500)
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.picturesContainer.mainContext)
    }

#endif
