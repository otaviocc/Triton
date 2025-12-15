#if DEBUG

    import WebpageNetworkService

    enum WebpageNetworkServiceMother {

        // MARK: - Nested types

        private final class FakeWebpageNetworkService: WebpageNetworkServiceProtocol {

            // MARK: - Public

            func webpageStream() -> AsyncStream<WebResponse> {
                AsyncStream { continuation in
                    continuation.yield(WebResponseMother.makeWebResponse())
                    continuation.finish()
                }
            }

            func fetchWebpage(for address: String) async throws {}
            func updateWebpage(address: String, content: String) async throws {}
        }

        // MARK: - Public

        static func makeWebpageNetworkService() -> any WebpageNetworkServiceProtocol {
            FakeWebpageNetworkService()
        }
    }

#endif
