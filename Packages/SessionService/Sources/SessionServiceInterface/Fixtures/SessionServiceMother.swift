#if DEBUG

    public enum SessionServiceMother {

        // MARK: - Nested types

        private final class FakeSessionService: SessionServiceProtocol {

            // MARK: - Properties

            let accountValue: Account
            let addressValue: Address

            // MARK: - Lifecycle

            init(
                account: Account,
                address: Address
            ) {
                accountValue = account
                addressValue = address
            }

            // MARK: - Public

            var account: Account {
                get async { accountValue }
            }

            var address: Address {
                get async { addressValue }
            }

            func observeAccount() -> AsyncStream<Account> {
                AsyncStream { continuation in
                    continuation.yield(accountValue)
                    continuation.finish()
                }
            }

            func setCurrentAccount(
                _ currentAccount: CurrentAccount
            ) async {}

            func observeAddress() -> AsyncStream<Address> {
                AsyncStream { continuation in
                    continuation.yield(addressValue)
                    continuation.finish()
                }
            }

            func setSelectedAddress(
                _ address: SelectedAddress
            ) async {}

            func observeSession() -> AsyncStream<Session> {
                AsyncStream { continuation in
                    let session: Session = switch (accountValue, addressValue) {
                    case let (.account(currentAccount), .address(selectedAddress)):
                        .session(account: currentAccount, selectedAddress: selectedAddress)
                    default:
                        .notAvailable
                    }
                    continuation.yield(session)
                    continuation.finish()
                }
            }

            func clearSession() async {}
        }

        // MARK: - Public

        public static func makeSessionService(
            account: Account = .notSynchronized,
            address: Address = .notSet
        ) -> any SessionServiceProtocol {
            FakeSessionService(
                account: account,
                address: address
            )
        }
    }

#endif
