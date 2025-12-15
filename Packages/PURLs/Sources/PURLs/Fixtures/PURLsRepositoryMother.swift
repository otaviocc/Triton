#if DEBUG

    import AuthSessionServiceInterface
    import PURLsPersistenceService
    import PURLsRepository
    import SwiftData

    enum PURLsRepositoryMother {

        // MARK: - Nested types

        private final class FakePURLsRepository: PURLsRepositoryProtocol {

            // MARK: - Properties

            var purlsContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = PURLsPersistenceServiceFactory()
                .makePURLsPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await PURL.makePURL(
                        count: count,
                        in: purlsContainer
                    )
                }
            }

            // MARK: - Public

            func fetchPURLs() {}
            func addPURL(address: String, name: String, url: String) {}
            func deletePURL(address: String, name: String) async throws {}
        }

        // MARK: - Public

        static func makePURLsRepository(
            count: Int = 5
        ) -> any PURLsRepositoryProtocol {
            FakePURLsRepository(count: count)
        }
    }

#endif
