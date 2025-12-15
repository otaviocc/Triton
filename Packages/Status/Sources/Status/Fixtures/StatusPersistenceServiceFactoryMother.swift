#if DEBUG

    import AuthSessionServiceInterface
    import StatusPersistenceService

    enum StatusPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakeStatusPersistenceServiceFactory: StatusPersistenceServiceFactoryProtocol {

            func makeStatusPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> StatusPersistenceServiceProtocol {
                StatusPersistenceServiceFactory()
                    .makeStatusPersistenceService(
                        inMemory: true,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makeStatusPersistenceServiceFactory() -> StatusPersistenceServiceFactoryProtocol {
            FakeStatusPersistenceServiceFactory()
        }
    }

#endif
