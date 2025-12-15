#if DEBUG

    import AuthSessionServiceInterface
    import PicsPersistenceService

    enum PicsPersistenceServiceFactoryMother {

        // MARK: - Nested types

        private final class FakePicsPersistenceServiceFactory: PicsPersistenceServiceFactoryProtocol {

            // MARK: - Public

            func makePicsPersistenceService(
                inMemory: Bool,
                authSessionService: any AuthSessionServiceProtocol
            ) -> PicsPersistenceServiceProtocol {
                PicsPersistenceServiceFactory()
                    .makePicsPersistenceService(
                        inMemory: inMemory,
                        authSessionService: authSessionService
                    )
            }
        }

        // MARK: - Public

        static func makePicsPersistenceServiceFactory() -> PicsPersistenceServiceFactoryProtocol {
            FakePicsPersistenceServiceFactory()
        }
    }

#endif
