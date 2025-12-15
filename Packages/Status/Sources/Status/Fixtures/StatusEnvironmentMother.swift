#if DEBUG

    import AuthSessionServiceInterface
    import SessionServiceInterface
    import StatusNetworkService
    import StatusPersistenceService
    import StatusRepository

    enum StatusEnvironmentMother {

        // MARK: - Public

        static func makeStatusEnvironment() -> StatusEnvironment {
            .init(
                repositoryFactory: StatusRepositoryFactoryMother.makeStatusRepositoryFactory(),
                networkServiceFactory: StatusNetworkServiceFactoryMother.makeStatusNetworkServiceFactory(),
                persistenceServiceFactory: StatusPersistenceServiceFactoryMother.makeStatusPersistenceServiceFactory(),
                sessionService: SessionServiceMother.makeSessionService(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                networkClient: MicroClientMother.makeNetworkClient(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
