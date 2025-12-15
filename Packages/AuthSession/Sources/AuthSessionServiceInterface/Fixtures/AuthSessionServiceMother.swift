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
