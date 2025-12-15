#if DEBUG

    import AuthSessionServiceInterface
    import NowPersistenceService

    enum NowPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakeNowPersistenceServiceFactory: NowPersistenceServiceFactoryProtocol {

            // MARK: - Public

            func makeNowPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> NowPersistenceServiceProtocol {
                NowPersistenceServiceFactory()
                    .makeNowPersistenceService(
                        inMemory: inMemory,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makeNowPersistenceServiceFactory() -> NowPersistenceServiceFactoryProtocol {
            FakeNowPersistenceServiceFactory()
        }
    }

#endif
