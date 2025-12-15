#if DEBUG

    import MicroClient
    import PURLsNetworkService

    enum PURLsNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakePURLsNetworkServiceFactory: PURLsNetworkServiceFactoryProtocol {

            func makePURLsNetworkService(
                networkClient: NetworkClientProtocol
            ) -> any PURLsNetworkServiceProtocol {
                PURLsNetworkServiceMother.makePURLsNetworkService()
            }
        }

        // MARK: - Public

        static func makePURLsNetworkServiceFactory() -> PURLsNetworkServiceFactoryProtocol {
            FakePURLsNetworkServiceFactory()
        }
    }

#endif
