#if DEBUG

    import Foundation
    import PicsNetworkService
    import PicsPersistenceService

    enum PicsNetworkServiceMother {

        // MARK: - Nested types

        private final class FakePicsNetworkService: PicsNetworkServiceProtocol {

            // MARK: - Public

            func fetchPictures(for address: String) async throws -> [PictureResponse] { [] }
            func deletePicture(address: String, pictureID: String) async throws {}
            func updatePicture(
                address: String,
                pictureID: String,
                caption: String,
                alt: String,
                tags: [String]
            ) async throws {}
            func uploadPicture(
                address: String,
                data: Data,
                caption: String,
                alt: String,
                isHidden: Bool,
                tags: [String]
            ) async throws {}
        }

        // MARK: - Public

        static func makePicsNetworkService() -> any PicsNetworkServiceProtocol {
            FakePicsNetworkService()
        }
    }

#endif
