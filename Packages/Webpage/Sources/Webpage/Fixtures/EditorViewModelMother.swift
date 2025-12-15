#if DEBUG

    import SessionServiceInterface
    import WebpageRepository

    enum EditorViewMother {

        // MARK: - Public

        @MainActor
        static func makeEditorViewModel() -> EditorViewModel {
            .init(
                address: "alice",
                repository: WebpageRepositoryMother.makeWebpageRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
