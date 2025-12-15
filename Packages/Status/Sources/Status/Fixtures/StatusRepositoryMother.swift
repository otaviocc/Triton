#if DEBUG

    import AuthSessionServiceInterface
    import StatusPersistenceService
    import StatusRepository
    import SwiftData

    enum StatusRepositoryMother {

        // MARK: - Nested types

        private final class FakeStatusRepository: StatusRepositoryProtocol {

            // MARK: - Properties

            var statusesContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = StatusPersistenceServiceFactory()
                .makeStatusPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int = 5) {
                Task {
                    await Status.makeStatus(
                        count: count,
                        in: statusesContainer
                    )
                }
            }

            // MARK: - Public

            func postStatus(
                address: String,
                emoji: String,
                content: String
            ) async throws {}

            func fetchStatuses() async throws {}
            func muteAddress(address: String) async throws {}
            func unmuteAddress(address: String) async throws {}
            func muteKeyword(keyword: String) async throws {}
            func unmuteKeyword(keyword: String) async throws {}
        }

        // MARK: - Public

        static func makeStatusRepository() -> StatusRepositoryProtocol {
            FakeStatusRepository()
        }
    }

#endif
