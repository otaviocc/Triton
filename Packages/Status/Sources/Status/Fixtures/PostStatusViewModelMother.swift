#if DEBUG

    import SessionServiceInterface

    enum PostStatusViewModelMother {

        // MARK: - Public

        @MainActor
        static func makePostStatusViewModel() -> PostStatusViewModel {
            .init(
                content: "This is a test",
                emoji: "🤣",
                repository: StatusRepositoryMother.makeStatusRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
