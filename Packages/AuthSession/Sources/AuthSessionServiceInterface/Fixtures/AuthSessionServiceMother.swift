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

    import Foundation

    public enum AuthSessionServiceMother {

        // MARK: - Nested types

        private actor FakeAuthSessionService: AuthSessionServiceProtocol {

            // MARK: - Properties

            private var _accessToken: String?
            private var _isLoggedIn: Bool

            var accessToken: String? {
                _accessToken
            }

            var isLoggedIn: Bool {
                _isLoggedIn
            }

            // MARK: - Lifecycle

            init(
                accessToken: String? = nil,
                isLoggedIn: Bool
            ) {
                _accessToken = accessToken
                _isLoggedIn = isLoggedIn
            }

            // MARK: - Public

            func setAccessToken(_ token: String?) async {
                _accessToken = token
                _isLoggedIn = token != nil
            }

            nonisolated func observeLoginState() -> AsyncStream<Bool> {
                AsyncStream { continuation in
                    Task {
                        await continuation.yield(self.isLoggedIn)
                        continuation.finish()
                    }
                }
            }

            nonisolated func observeLogoutEvents() -> AsyncStream<Void> {
                AsyncStream { continuation in
                    continuation.finish()
                }
            }
        }

        // MARK: - Public

        public static func makeAuthSessionService(
            loggedIn: Bool = false
        ) -> any AuthSessionServiceProtocol {
            FakeAuthSessionService(
                accessToken: loggedIn ? "test-token" : nil,
                isLoggedIn: loggedIn
            )
        }
    }

#endif
