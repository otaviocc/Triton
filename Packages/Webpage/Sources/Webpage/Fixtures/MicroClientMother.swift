#if DEBUG

    import Foundation
    import MicroClient

    enum MicroClientMother {

        // MARK: - Public

        static func makeNetworkClient() -> NetworkClientProtocol {
            NetworkClient(
                configuration: .init(
                    session: URLSession.shared,
                    defaultDecoder: JSONDecoder(),
                    defaultEncoder: JSONEncoder(),
                    baseURL: URL(string: "localhost")!
                )
            )
        }
    }

#endif
