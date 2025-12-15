#if DEBUG

    import AuthSessionServiceInterface
    import SessionServiceInterface
    import WebpageNetworkService
    import WebpagePersistenceService
    import WebpageRepository

    enum WebpageRepositoryFactoryMother {

        // MARK: - Nested types

        private final class FakeWebpageRepositoryFactory: WebpageRepositoryFactoryProtocol {

            // MARK: - Public

            func makeWebpageRepository(
                networkService: any WebpageNetworkServiceProtocol,
                persistenceService: WebpagePersistenceServiceProtocol,
                authSessionService: any AuthSessionServiceProtocol,
                sessionService: any SessionServiceProtocol
            ) -> any WebpageRepositoryProtocol {
                WebpageRepositoryMother.makeWebpageRepository()
            }
        }

        // MARK: - Public

        static func makeWebpageRepositoryFactory() -> WebpageRepositoryFactoryProtocol {
            FakeWebpageRepositoryFactory()
        }
    }

#endif
