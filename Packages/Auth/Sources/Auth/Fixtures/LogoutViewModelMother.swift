#if DEBUG

    import AuthRepository
    import Foundation

    enum LogoutViewModelMother {

        // MARK: - Nested types

        private final class FakeAuthRepository: AuthRepositoryProtocol {

            func handleDeepLinkURL(_ url: URL) async throws {}
            func storeToken(accessToken: String) {}
            func removeAccessToken() {}

            func accessToken() async throws -> String {
                "some access token"
            }
        }

        // MARK: - Public

        @MainActor
        static func makeLogoutViewModel() -> LogoutViewModel {
            .init(
                repository: FakeAuthRepository()
            )
        }
    }

#endif
