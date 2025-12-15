#if DEBUG

    import AuthSessionServiceInterface
    import PicsNetworkService
    import PicsPersistenceService
    import PicsRepository
    import SessionServiceInterface

    enum PicsEnvironmentMother {

        // MARK: - Public

        static func makePicsEnvironment() -> PicsEnvironment {
            .init(
                networkServiceFactory: PicsNetworkServiceFactoryMother.makePicsNetworkServiceFactory(),
                persistenceServiceFactory: PicsPersistenceServiceFactoryMother.makePicsPersistenceServiceFactory(),
                repositoryFactory: PicsRepositoryFactoryMother.makePicsRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
