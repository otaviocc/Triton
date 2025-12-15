#if DEBUG

    import AuthSessionServiceInterface
    import PastebinPersistenceService
    import PastebinRepository
    import SwiftData

    enum PastebinRepositoryMother {

        // MARK: - Nested types

        private final class FakePastebinRepository: PastebinRepositoryProtocol {

            // MARK: - Properties

            var pastebinContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = PastebinPersistenceServiceFactory()
                .makePastebinPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await Paste.makePaste(
                        count: count,
                        in: pastebinContainer
                    )
                }
            }

            // MARK: - Public

            func fetchPastes() async throws {}
            func createOrUpdatePaste(address: String, title: String, content: String, isListed: Bool) async throws {}
            func deletePaste(address: String, title: String) async throws {}
        }

        // MARK: - Public

        static func makePastebinRepository(
            count: Int = 5
        ) -> any PastebinRepositoryProtocol {
            FakePastebinRepository(count: count)
        }
    }

#endif
