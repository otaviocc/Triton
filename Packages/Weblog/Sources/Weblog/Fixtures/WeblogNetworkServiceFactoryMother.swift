#if DEBUG

    import MicroClient
    import WeblogNetworkService

    enum WeblogNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakeWeblogNetworkServiceFactory: WeblogNetworkServiceFactoryProtocol {

            // MARK: - Public

            func makeWeblogNetworkService(
                networkClient: NetworkClientProtocol
            ) -> any WeblogNetworkServiceProtocol {
                WeblogNetworkServiceMother.makeWeblogNetworkService()
            }
        }

        // MARK: - Public

        static func makeWeblogNetworkServiceFactory() -> WeblogNetworkServiceFactoryProtocol {
            FakeWeblogNetworkServiceFactory()
        }
    }

#endif
