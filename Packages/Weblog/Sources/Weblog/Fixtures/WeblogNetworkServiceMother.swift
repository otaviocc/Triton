#if DEBUG

    import Foundation
    import WeblogNetworkService
    import WeblogPersistenceService

    enum WeblogNetworkServiceMother {

        // MARK: - Nested types

        private final class FakeWeblogNetworkService: WeblogNetworkServiceProtocol {

            // MARK: - Public

            func fetchWeblogEntry(for address: String, entryID: String) async throws -> EntryResponse {
                EntryResponseMother.makeEntryResponse()
            }

            func fetchWeblogEntries(for address: String) async throws -> [EntryResponse] {
                EntryResponseMother.makeEntryResponses(count: 2)
            }

            func createWeblogEntry(
                address: String,
                content: String,
                status: String,
                date: Date
            ) async throws -> EntryResponse {
                EntryResponseMother.makeEntryResponse()
            }

            func updateWeblogEntry(
                address: String,
                entryID: String,
                content: String,
                status: String,
                date: Date
            ) async throws -> EntryResponse {
                EntryResponseMother.makeEntryResponse()
            }

            func deleteWeblogEntry(address: String, entryID: String) async throws {}
        }

        // MARK: - Public

        static func makeWeblogNetworkService() -> any WeblogNetworkServiceProtocol {
            FakeWeblogNetworkService()
        }
    }

#endif
