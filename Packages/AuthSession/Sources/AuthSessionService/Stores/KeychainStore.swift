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
