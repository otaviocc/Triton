#if DEBUG

    import AuthSessionServiceInterface
    import NowNetworkService
    import NowPersistenceService
    import NowRepository
    import SessionServiceInterface

    enum NowRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakeNowRepositoryFactory: NowRepositoryFactoryProtocol {

            // MARK: - Public

            func makeNowRepository(
                networkService: NowNetworkServiceProtocol,
                persistenceService: NowPersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any NowRepositoryProtocol {
                NowRepositoryMother.makeNowRepository()
            }
        }

        // MARK: - Public

        static func makeNowRepositoryFactory() -> NowRepositoryFactoryProtocol {
            FakeNowRepositoryFactory()
        }
    }

#endif
