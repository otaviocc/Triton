#if DEBUG

    import AuthSessionServiceInterface
    import PastebinNetworkService
    import PastebinPersistenceService
    import PastebinRepository
    import SessionServiceInterface

    enum PastebinRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakePastebinRepositoryFactory: PastebinRepositoryFactoryProtocol {

            // MARK: - Public

            func makePastebinRepository(
                networkService: any PastebinNetworkServiceProtocol,
                persistenceService: PastebinPersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any PastebinRepositoryProtocol {
                PastebinRepositoryMother.makePastebinRepository()
            }
        }

        // MARK: - Public

        static func makePastebinRepositoryFactory() -> PastebinRepositoryFactoryProtocol {
            FakePastebinRepositoryFactory()
        }
    }

#endif
