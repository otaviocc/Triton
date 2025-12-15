#if DEBUG

    import AuthSessionServiceInterface
    import Foundation
    import PicsPersistenceService
    import PicsRepository
    import SessionServiceInterface
    import SwiftData

    enum PicsRepositoryMother {

        // MARK: - Nested types

        private final class FakePicsRepository: PicsRepositoryProtocol {

            // MARK: - Properties

            var picturesContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = PicsPersistenceServiceFactory()
                .makePicsPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await SomePicture.makePictures(
                        count: count,
                        in: picturesContainer
                    )
                }
            }

            // MARK: - Public

            func fetchPictures() async throws {}
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

        static func makePicsRepository(
            count: Int = 5
        ) -> any PicsRepositoryProtocol {
            FakePicsRepository(count: count)
        }
    }

#endif
