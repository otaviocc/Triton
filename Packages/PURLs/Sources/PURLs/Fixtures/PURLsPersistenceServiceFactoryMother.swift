#if DEBUG

    import AuthSessionServiceInterface
    import PURLsPersistenceService

    enum PURLsPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakePURLsPersistenceServiceFactory: PURLsPersistenceServiceFactoryProtocol {

            func makePURLsPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> PURLsPersistenceServiceProtocol {
                PURLsPersistenceServiceFactory()
                    .makePURLsPersistenceService(
                        inMemory: inMemory,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makePURLsPersistenceServiceFactory() -> PURLsPersistenceServiceFactoryProtocol {
            FakePURLsPersistenceServiceFactory()
        }
    }

#endif
