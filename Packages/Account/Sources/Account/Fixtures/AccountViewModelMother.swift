#if DEBUG

    import Foundation
    import SessionServiceInterface

    enum AccountViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeAccountViewModel(
            account: Account
        ) -> AccountViewModel {
            .init(
                sessionService: SessionServiceMother
                    .makeSessionService(
                        account: account
                    )
            )
        }
    }

#endif
