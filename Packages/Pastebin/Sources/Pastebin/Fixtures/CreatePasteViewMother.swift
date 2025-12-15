#if DEBUG

    import PastebinRepository
    import SessionServiceInterface

    enum CreatePasteViewMother {

        // MARK: - Public

        @MainActor
        static func makeCreatePasteViewModel() -> CreatePasteViewModel {
            .init(
                repository: PastebinRepositoryMother.makePastebinRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
