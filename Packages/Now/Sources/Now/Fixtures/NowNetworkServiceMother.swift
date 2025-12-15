#if DEBUG

    import NowNetworkService

    enum NowNetworkServiceMother {

        // MARK: - Nested types

        private final class FakeNowNetworkService: NowNetworkServiceProtocol {

            // MARK: - Public

            func nowStream() -> AsyncStream<NowResponse> {
                AsyncStream { continuation in
                    continuation.yield(NowResponseMother.makeNowResponse())
                    continuation.finish()
                }
            }

            func fetchNowPage(for address: String) async throws {}
            func updateNowPage(address: String, content: String, listed: Bool) async throws {}
        }

        // MARK: - Public

        static func makeNowNetworkService() -> any NowNetworkServiceProtocol {
            FakeNowNetworkService()
        }
    }

#endif
