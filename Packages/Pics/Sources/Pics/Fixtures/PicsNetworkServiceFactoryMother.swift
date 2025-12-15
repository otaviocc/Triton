#if DEBUG

    import MicroClient
    import PicsNetworkService

    enum PicsNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakePicsNetworkServiceFactory: PicsNetworkServiceFactoryProtocol {

            // MARK: - Public

            func makePicsNetworkService(
                networkClient: NetworkClientProtocol
            ) -> any PicsNetworkServiceProtocol {
                PicsNetworkServiceMother.makePicsNetworkService()
            }
        }

        // MARK: - Public

        static func makePicsNetworkServiceFactory() -> PicsNetworkServiceFactoryProtocol {
            FakePicsNetworkServiceFactory()
        }
    }

#endif
