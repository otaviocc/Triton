#if DEBUG

    import AuthSessionServiceInterface
    import Foundation
    import SessionServiceInterface
    import SwiftData
    import WeblogPersistenceService
    import WeblogRepository

    enum WeblogRepositoryMother {

        // MARK: - Nested types

        private final class FakeWeblogRepository: WeblogRepositoryProtocol {

            // MARK: - Properties

            var entriesContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = WeblogPersistenceServiceFactory()
                .makeWeblogPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await WeblogEntry.makeWeblogEntry(
                        count: count,
                        in: entriesContainer
                    )
                }
            }

            // MARK: - Public

            func fetchEntries() async throws {}
            func createOrUpdateEntry(address: String, entryID: String?, body: String, date: Date) async throws {}
            func deleteEntry(address: String, entryID: String) async throws {}
        }

        // MARK: - Public

        static func makeWeblogRepository(
            count: Int = 5
        ) -> any WeblogRepositoryProtocol {
            FakeWeblogRepository(count: count)
        }
    }

#endif
