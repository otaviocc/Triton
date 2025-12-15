#if DEBUG

    import AuthSessionServiceInterface
    import WebpagePersistenceService

    enum WebpagePersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakeWebpagePersistenceServiceFactory: WebpagePersistenceServiceFactoryProtocol {

            // MARK: - Public

            func makeWebpagePersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> WebpagePersistenceServiceProtocol {
                WebpagePersistenceServiceFactory()
                    .makeWebpagePersistenceService(
                        inMemory: inMemory,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makeWebpagePersistenceServiceFactory() -> WebpagePersistenceServiceFactoryProtocol {
            FakeWebpagePersistenceServiceFactory()
        }
    }

#endif
