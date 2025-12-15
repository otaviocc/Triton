#if DEBUG

    import AuthSessionServiceInterface
    import PastebinNetworkService
    import PastebinPersistenceService
    import PastebinRepository
    import SessionServiceInterface

    enum PastebinEnvironmentMother {

        static func makePastebinEnvironment() -> PastebinEnvironment {
            .init(
                networkServiceFactory: PastebinNetworkServiceFactoryMother.makePastebinNetworkServiceFactory(),
                persistenceServiceFactory: PastebinPersistenceServiceFactoryMother
                    .makePastebinPersistenceServiceFactory(),
                repositoryFactory: PastebinRepositoryFactoryMother.makePastebinRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
