#if DEBUG

    import AuthSessionServiceInterface
    import PicsNetworkService
    import PicsPersistenceService
    import PicsRepository
    import SessionServiceInterface

    enum PicsRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakePicsRepositoryFactory: PicsRepositoryFactoryProtocol {

            // MARK: - Public

            func makePicsRepository(
                networkService: any PicsNetworkServiceProtocol,
                persistenceService: any PicsPersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any PicsRepositoryProtocol {
                PicsRepositoryMother.makePicsRepository()
            }
        }

        // MARK: - Public

        static func makePicsRepositoryFactory() -> any PicsRepositoryFactoryProtocol {
            FakePicsRepositoryFactory()
        }
    }

#endif
