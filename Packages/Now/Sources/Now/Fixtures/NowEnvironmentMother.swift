#if DEBUG

    import AuthSessionServiceInterface
    import NowNetworkService
    import NowPersistenceService
    import NowRepository
    import SessionServiceInterface

    enum NowEnvironmentMother {

        // MARK: - Public

        static func makeNowEnvironment() -> NowEnvironment {
            .init(
                networkServiceFactory: NowNetworkServiceFactoryMother.makeNowNetworkServiceFactory(),
                persistenceServiceFactory: NowPersistenceServiceFactoryMother.makeNowPersistenceServiceFactory(),
                repositoryFactory: NowRepositoryFactoryMother.makeNowRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
