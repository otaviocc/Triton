#if DEBUG

    import NowRepository
    import SessionServiceInterface

    enum NowViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeNowViewModel() -> NowViewModel {
            .init(
                markdown: "Foo",
                timestamp: 12_312_312,
                listed: true,
                address: "otaviocc",
                isCurrent: true
            )
        }
    }

#endif
