#if DEBUG

    import Foundation
    import SessionServiceInterface

    enum AccountDetailsViewModelMother {

        @MainActor
        static func makeAccountDetailsViewModel() -> AccountDetailsViewModel {
            .init(
                currentAccount: CurrentAccountMother.makeCurrent(),
                sessionService: SessionServiceMother.makeSessionService(
                    address: .address(
                        current: "otaviocc"
                    )
                )
            )
        }
    }

#endif
