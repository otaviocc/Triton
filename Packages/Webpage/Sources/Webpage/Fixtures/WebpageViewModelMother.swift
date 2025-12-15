#if DEBUG

    import SessionServiceInterface
    import WebpageRepository

    enum WebpageViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeWebpageViewModel() -> WebpageViewModel {
            .init(
                markdown: "Foo",
                timestamp: 12_312_312,
                address: "otaviocc",
                isCurrent: true
            )
        }
    }

#endif
