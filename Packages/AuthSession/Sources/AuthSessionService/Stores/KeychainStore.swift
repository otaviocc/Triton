import Foundation

protocol KeychainStoreProtocol: AnyObject, Sendable {

    /// Value stored in the Keychain.
    var wrappedValue: String? { get set }
}

final class KeychainStore: KeychainStoreProtocol, @unchecked Sendable {

    // MARK: - Nested types

    typealias ItemDeleter = (
        CFDictionary
    ) -> OSStatus

    typealias ItemAdder = (
        CFDictionary,
        UnsafeMutablePointer<CFTypeRef?>?
    ) -> OSStatus

    typealias ItemCopyMatcher = (
        CFDictionary,
        UnsafeMutablePointer<CFTypeRef?>?
    ) -> OSStatus

    // MARK: - Properties

    var wrappedValue: String? {
        get {
            guard let data = load(key: key) else {
                return nil
            }

            return String(data: data, encoding: .utf8)
        }

        set {
            guard
                let value = newValue,
                let data = value.data(using: .utf8)
            else {
                delete(key)
                return
            }

            save(key: key, data: data)
        }
    }

    private let key: String
    private let itemDeleter: ItemDeleter
    private let itemAdder: ItemAdder
    private let itemCopyMatcher: ItemCopyMatcher

    // MARK: - Lifecycle

    init(
        _ key: String,
        itemDeleter: @escaping ItemDeleter = SecItemDelete,
        itemAdder: @escaping ItemAdder = SecItemAdd,
        itemCopyMatcher: @escaping ItemCopyMatcher = SecItemCopyMatching
    ) {
        self.key = key
        self.itemDeleter = itemDeleter
        self.itemAdder = itemAdder
        self.itemCopyMatcher = itemCopyMatcher
    }

    // MARK: - Private

    @discardableResult
    private func save(
        key: String,
        data: Data
    ) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String: Any]

        _ = itemDeleter(
            query as CFDictionary
        )

        return itemAdder(
            query as CFDictionary,
            nil
        )
    }

    private func load(
        key: String
    ) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var data: AnyObject?
        let status = itemCopyMatcher(
            query as CFDictionary,
            &data
        )

        if status == noErr {
            return data as? Data
        } else {
            return nil
        }
    }

    @discardableResult
    private func delete(
        _ key: String
    ) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as [String: Any]

        return itemDeleter(
            query as CFDictionary
        )
    }
}
