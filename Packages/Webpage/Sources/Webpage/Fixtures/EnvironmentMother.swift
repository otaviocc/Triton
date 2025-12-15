#if DEBUG

    import AuthSessionServiceInterface
    import SessionServiceInterface
    import WebpageNetworkService
    import WebpagePersistenceService
    import WebpageRepository

    enum WebpageEnvironmentMother {

        // MARK: - Public

        static func makeWebpageEnvironment() -> WebpageEnvironment {
            .init(
                networkServiceFactory: WebpageNetworkServiceFactoryMother.makeWebpageNetworkService(),
                persistenceServiceFactory: WebpagePersistenceServiceFactoryMother
                    .makeWebpagePersistenceServiceFactory(),
                repositoryFactory: WebpageRepositoryFactoryMother.makeWebpageRepositoryFactory(),
                networkClient: MicroClientMother.makeNetworkClient(),
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
