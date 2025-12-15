#if DEBUG

    import AuthSessionServiceInterface
    import SwiftData
    import WebpagePersistenceService
    import WebpageRepository

    enum WebpageRepositoryMother {

        // MARK: - Nested types

        private final class FakeWebpageRepository: WebpageRepositoryProtocol {

            // MARK: - Properties

            var webpageContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = WebpagePersistenceServiceFactory()
                .makeWebpagePersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await Webpage.makeWebpage(
                        count: 5,
                        in: webpageContainer
                    )
                }
            }

            // MARK: - Public

            func fetchWebpage() async throws {}
            func updateWebpage(address: String, content: String) async throws {}
        }

        // MARK: - Public

        static func makeWebpageRepository(
            count: Int = 5
        ) -> any WebpageRepositoryProtocol {
            FakeWebpageRepository(count: count)
        }
    }

#endif
