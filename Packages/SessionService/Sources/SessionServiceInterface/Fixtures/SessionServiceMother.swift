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
