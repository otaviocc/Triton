#if DEBUG

    import AuthSessionServiceInterface
    import PURLsNetworkService
    import PURLsPersistenceService
    import PURLsRepository
    import SessionServiceInterface

    enum PURLsRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakePURLsRepositoryFactory: PURLsRepositoryFactoryProtocol {

            func makePURLsRepository(
                networkService: any PURLsNetworkServiceProtocol,
                persistenceService: PURLsPersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any PURLsRepositoryProtocol {
                PURLsRepositoryMother.makePURLsRepository()
            }
        }

        // MARK: - Public

        static func makePURLsRepositoryFactory() -> PURLsRepositoryFactoryProtocol {
            FakePURLsRepositoryFactory()
        }
    }

#endif
