#if DEBUG

    enum NowListViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeNowListViewModel() -> NowListViewModel {
            .init(
                address: "otaviocc",
                repository: NowRepositoryMother.makeNowRepository()
            )
        }
    }

#endif
