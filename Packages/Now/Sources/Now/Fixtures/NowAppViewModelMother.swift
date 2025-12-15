#if DEBUG

    import AuthSessionServiceInterface
    import Foundation
    import NowRepository
    import SessionServiceInterface

    enum NowAppViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeNowAppViewModel(
            loggedIn: Bool = true,
            account: Account = .notSynchronized,
            address: Address = .notSet
        ) -> NowAppViewModel {
            let authSessionService = AuthSessionServiceMother
                .makeAuthSessionService(
                    loggedIn: loggedIn
                )

            let sessionService = SessionServiceMother
                .makeSessionService(
                    account: account,
                    address: address
                )

            let repository = NowRepositoryMother
                .makeNowRepository()

            return .init(
                authSessionService: authSessionService,
                sessionService: sessionService,
                repository: repository
            )
        }
    }

#endif
