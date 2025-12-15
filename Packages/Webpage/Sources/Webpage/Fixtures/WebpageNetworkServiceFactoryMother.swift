#if DEBUG

    import MicroClient
    import WebpageNetworkService

    enum WebpageNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakeWebpageNetworkServiceFactory: WebpageNetworkServiceFactoryProtocol {

            // MARK: - Public

            func makeWebpageNetworkService(
                networkClient: NetworkClientProtocol
            ) -> any WebpageNetworkServiceProtocol {
                WebpageNetworkServiceMother.makeWebpageNetworkService()
            }
        }

        // MARK: - Public

        static func makeWebpageNetworkService() -> WebpageNetworkServiceFactoryProtocol {
            FakeWebpageNetworkServiceFactory()
        }
    }

#endif
