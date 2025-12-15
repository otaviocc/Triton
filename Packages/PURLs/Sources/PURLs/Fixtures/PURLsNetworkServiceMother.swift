#if DEBUG

    import PURLsNetworkService

    enum PURLsNetworkServiceMother {

        // MARK: - NestedTypes

        private final class FakePURLsNetworkService: PURLsNetworkServiceProtocol {

            // MARK: - Public

            func purlsStream() -> AsyncStream<[PURLResponse]> {
                AsyncStream { continuation in
                    continuation.yield([])
                    continuation.finish()
                }
            }

            func fetchPURLs(for address: String) {}
            func addPURL(address: String, name: String, url: String) {}
            func deletePURL(address: String, name: String) async throws {}
        }

        // MARK: - Public

        static func makePURLsNetworkService() -> any PURLsNetworkServiceProtocol {
            FakePURLsNetworkService()
        }
    }

#endif
