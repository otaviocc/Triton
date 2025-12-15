#if DEBUG

    enum PastesListViewModelMother {

        // MARK: - Public

        @MainActor
        static func makePastesListViewModel() -> PastesListViewModel {
            .init(
                address: "otaviocc",
                sort: .titleAscending,
                repository: PastebinRepositoryMother.makePastebinRepository()
            )
        }
    }

#endif
