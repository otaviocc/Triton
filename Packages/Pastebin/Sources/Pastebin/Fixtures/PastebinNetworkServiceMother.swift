#if DEBUG

    import PastebinNetworkService

    enum PastebinNetworkServiceMother {

        // MARK: - NestedTypes

        private final class FakePastebinNetworkService: PastebinNetworkServiceProtocol {

            // MARK: - Public

            func pastesStream() -> AsyncStream<[PasteResponse]> {
                AsyncStream { continuation in
                    continuation.yield([])
                    continuation.finish()
                }
            }

            func fetchPastes(for address: String) async throws {}
            func createOrUpdatePaste(address: String, title: String, content: String, listed: Bool) async throws {}
            func deletePaste(address: String, title: String) async throws {}
        }

        // MARK: - Public

        static func makePastebinNetworkService() -> any PastebinNetworkServiceProtocol {
            FakePastebinNetworkService()
        }
    }

#endif
