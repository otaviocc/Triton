#if DEBUG

    import AuthSessionServiceInterface
    import NowPersistenceService
    import NowRepository
    import SwiftData

    enum NowRepositoryMother {

        // MARK: - Nested types

        private final class FakeNowRepository: NowRepositoryProtocol {

            // MARK: - Properties

            var nowContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = NowPersistenceServiceFactory()
                .makeNowPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await Now.makeNow(
                        count: count,
                        in: nowContainer
                    )
                }
            }

            // MARK: - Public

            func fetchNowPage() async throws {}
            func updateNowPage(address: String, content: String, isListed: Bool) async throws {}
        }

        // MARK: - Public

        static func makeNowRepository(
            count: Int = 5
        ) -> any NowRepositoryProtocol {
            FakeNowRepository(count: count)
        }
    }

#endif
