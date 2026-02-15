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
    import NowPersistenceService
    import NowRepository
    import SwiftData

    enum NowRepositoryMother {

        // MARK: - Nested types

        private final class FakeNowRepository: NowRepositoryProtocol {

            // MARK: - Properties

            var nowContainer: ModelContainer {
                persistenceService.container
            }

            private let persistenceService = NowPersistenceServiceFactory()
                .makeNowPersistenceService(
                    inMemory: true,
                    authSessionService: AuthSessionServiceMother.makeAuthSessionService()
                )

            // MARK: - Lifecycle

            init(count: Int) {
                Task {
                    await Now.makeNow(
                        count: count,
                        in: nowContainer
                    )
                }
            }

            // MARK: - Public

            func fetchNowPage() async throws {}

            func updateNowPage(
                address: String,
                content: String,
                isListed: Bool
            ) async throws {}
        }

        // MARK: - Public

        static func makeNowRepository(
            count: Int = 5
        ) -> any NowRepositoryProtocol {
            FakeNowRepository(count: count)
        }
    }

#endif
