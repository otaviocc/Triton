#if DEBUG

    import NowRepository
    import SessionServiceInterface

    enum EditorViewMother {

        // MARK: - Public

        @MainActor
        static func makeEditorViewModel() -> EditorViewModel {
            .init(
                address: "alice",
                isListed: true,
                repository: NowRepositoryMother.makeNowRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
