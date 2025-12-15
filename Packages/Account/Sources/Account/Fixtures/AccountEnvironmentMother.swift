#if DEBUG

    import SessionServiceInterface

    enum AccountEnvironmentMother {

        // MARK: - Public

        static func makeAccountEnvironment() -> AccountEnvironment {
            .init(
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
