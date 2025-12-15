#if DEBUG

    import MicroClient
    import StatusNetworkService

    enum StatusNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakeStatusNetworkServiceFactory: StatusNetworkServiceFactoryProtocol {

            func makeStatusNetworkService(
                networkClient: NetworkClientProtocol
            ) -> StatusNetworkServiceProtocol {
                StatusNetworkServiceMother.makeStatusNetworkService()
            }
        }

        // MARK: - Public

        static func makeStatusNetworkServiceFactory() -> StatusNetworkServiceFactoryProtocol {
            FakeStatusNetworkServiceFactory()
        }
    }

#endif
