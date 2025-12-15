#if DEBUG

    import AuthSessionServiceInterface
    import SessionServiceInterface
    import WeblogNetworkService
    import WeblogPersistenceService
    import WeblogRepository

    enum WeblogEnvironmentMother {

        // MARK: - Public

        static func makeWeblogEnvironment() -> WeblogEnvironment {
            .init(
                networkServiceFactory: WeblogNetworkServiceFactoryMother.makeWeblogNetworkServiceFactory(),
                persistenceServiceFactory: WeblogPersistenceServiceFactoryMother
                    .makeWeblogPersistenceServiceFactory(),
                repositoryFactory: WeblogRepositoryFactoryMother.makeWeblogRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
