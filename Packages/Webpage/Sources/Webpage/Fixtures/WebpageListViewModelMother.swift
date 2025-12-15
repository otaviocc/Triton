#if DEBUG

    enum WebpageListViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeWebpageListViewModel() -> WebpageListViewModel {
            .init(
                address: "otaviocc",
                repository: WebpageRepositoryMother.makeWebpageRepository()
            )
        }
    }

#endif
