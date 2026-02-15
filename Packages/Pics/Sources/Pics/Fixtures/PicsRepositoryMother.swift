// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

            func deletePicture(
                address: String,
                pictureID: String
            ) async throws {}

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
