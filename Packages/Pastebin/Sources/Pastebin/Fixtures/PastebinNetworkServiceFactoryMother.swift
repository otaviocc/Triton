#if DEBUG

    import MicroClient
    import PastebinNetworkService

    enum PastebinNetworkServiceFactoryMother {

        // MARK: - Nested types

        private struct FakePastebinNetworkServiceFactory: PastebinNetworkServiceFactoryProtocol {

            // MARK: - Public

            func makePastebinNetworkService(
                networkClient: NetworkClientProtocol
            ) -> PastebinNetworkServiceProtocol {
                PastebinNetworkServiceMother.makePastebinNetworkService()
            }
        }

        // MARK: - Public

        static func makePastebinNetworkServiceFactory() -> PastebinNetworkServiceFactoryProtocol {
            FakePastebinNetworkServiceFactory()
        }
    }

#endif
