#if DEBUG

    import AuthSessionServiceInterface
    import SessionServiceInterface
    import WeblogNetworkService
    import WeblogPersistenceService
    import WeblogRepository

    enum WeblogRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakeWeblogRepositoryFactory: WeblogRepositoryFactoryProtocol {

            // MARK: - Public

            func makeWeblogRepository(
                networkService: any WeblogNetworkServiceProtocol,
                persistenceService: any WeblogPersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any WeblogRepositoryProtocol {
                WeblogRepositoryMother.makeWeblogRepository()
            }
        }

        // MARK: - Public

        static func makeWeblogRepositoryFactory() -> any WeblogRepositoryFactoryProtocol {
            FakeWeblogRepositoryFactory()
        }
    }

#endif
