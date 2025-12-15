#if DEBUG

    import Foundation
    import PURLsRepository

    enum PURLsListViewModelMother {

        // MARK: - Public

        @MainActor
        static func makePURLsListViewModel() -> PURLsListViewModel {
            .init(
                address: "otaviocc",
                sort: .nameAscending,
                repository: PURLsRepositoryMother.makePURLsRepository()
            )
        }
    }

#endif
