#if DEBUG

    import AuthSessionServiceInterface
    import PastebinPersistenceService

    enum PastebinPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakePastebinPersistenceServiceFactory: PastebinPersistenceServiceFactoryProtocol {

            // MARK: - Public

            func makePastebinPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> PastebinPersistenceServiceProtocol {
                PastebinPersistenceServiceFactory()
                    .makePastebinPersistenceService(
                        inMemory: true,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makePastebinPersistenceServiceFactory() -> PastebinPersistenceServiceFactoryProtocol {
            FakePastebinPersistenceServiceFactory()
        }
    }

#endif
