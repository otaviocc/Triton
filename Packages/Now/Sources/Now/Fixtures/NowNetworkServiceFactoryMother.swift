#if DEBUG

    import MicroClient
    import NowNetworkService

    enum NowNetworkServiceFactoryMother {

        // MARK: - Nested types

        private final class FakeNowNetworkServiceFactory: NowNetworkServiceFactoryProtocol {

            // MARK: - Public

            func makeNowNetworkService(
                networkClient: NetworkClientProtocol
            ) -> NowNetworkServiceProtocol {
                NowNetworkServiceMother.makeNowNetworkService()
            }
        }

        // MARK: - Public

        static func makeNowNetworkServiceFactory() -> NowNetworkServiceFactoryProtocol {
            FakeNowNetworkServiceFactory()
        }
    }

#endif
