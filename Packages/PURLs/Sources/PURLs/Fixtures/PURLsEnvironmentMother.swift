#if DEBUG

    import AuthSessionServiceInterface
    import PURLsNetworkService
    import PURLsPersistenceService
    import PURLsRepository
    import SessionServiceInterface

    enum PURLsEnvironmentMother {

        static func makePURLsEnvironment() -> PURLsEnvironment {
            .init(
                networkServiceFactory: PURLsNetworkServiceFactoryMother.makePURLsNetworkServiceFactory(),
                persistenceServiceFactory: PURLsPersistenceServiceFactoryMother.makePURLsPersistenceServiceFactory(),
                repositoryFactory: PURLsRepositoryFactoryMother.makePURLsRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
