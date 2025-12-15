#if DEBUG

    import AuthSessionServiceInterface
    import WeblogPersistenceService

    enum WeblogPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakeWeblogPersistenceServiceFactory: WeblogPersistenceServiceFactoryProtocol {

            // MARK: - Public

            func makeWeblogPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> WeblogPersistenceServiceProtocol {
                WeblogPersistenceServiceFactory()
                    .makeWeblogPersistenceService(
                        inMemory: inMemory,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makeWeblogPersistenceServiceFactory() -> WeblogPersistenceServiceFactoryProtocol {
            FakeWeblogPersistenceServiceFactory()
        }
    }

#endif
