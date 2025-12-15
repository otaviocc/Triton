#if DEBUG

    enum KeychainStoreMother {

        // MARK: - Nested types

        private final class FakeKeychainStore: KeychainStoreProtocol, @unchecked Sendable {

            var wrappedValue: String?
        }

        // MARK: - Public

        static func makeKeychainStore() -> KeychainStoreProtocol {
            FakeKeychainStore()
        }
    }

#endif
