#if DEBUG

    import MicroClient
    import StatusNetworkService

    enum StatusNetworkServiceMother {

        // MARK: - Nested types

        private final class FakeStatusNetworkService: StatusNetworkServiceProtocol {

            // MARK: - Public

            func latestStatusStream() -> AsyncStream<[StatusResponse]> {
                AsyncStream { continuation in
                    continuation.yield([])
                    continuation.finish()
                }
            }

            func postStatus(
                address: String,
                emoji: String,
                content: String
            ) async throws {}

            func fetchStatuses() async throws -> [StatusResponse] { [] }
        }

        // MARK: - Public

        static func makeStatusNetworkService() -> StatusNetworkServiceProtocol {
            FakeStatusNetworkService()
        }
    }

#endif
