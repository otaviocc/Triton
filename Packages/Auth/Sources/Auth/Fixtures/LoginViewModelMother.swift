#if DEBUG

    import AuthRepository
    import Foundation

    enum LoginViewModelMother {

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
        static func makeLoginViewModel() -> LoginViewModel {
            .init(
                repository: FakeAuthRepository()
            )
        }
    }

#endif
