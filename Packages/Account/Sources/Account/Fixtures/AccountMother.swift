#if DEBUG

    import Foundation
    import SessionServiceInterface

    enum CurrentAccountMother {

        // MARK: - Public

        static func makeCurrent() -> CurrentAccount {
            .init(
                name: "Otavio",
                email: "foo@bar.abc",
                creation: .distantPast,
                addresses: [
                    .init(
                        address: "otaviocc",
                        creation: .distantPast,
                        expire: .distantFuture
                    ),
                    .init(
                        address: "otavio",
                        creation: Date(),
                        expire: .distantFuture
                    )
                ]
            )
        }
    }

#endif
