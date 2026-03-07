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

// swiftlint:disable identifier_name

import AuthSessionServiceInterface
import Testing
@testable import AuthSessionService

struct AuthSessionServiceTests {

    // MARK: - Properties

    private let service: any AuthSessionServiceProtocol
    private let fakeKeychainStore: KeychainStoreProtocol

    // MARK: - Lifecycle

    init() async throws {
        let store = KeychainStoreMother.makeKeychainStore()
        fakeKeychainStore = store

        service = AuthSessionService(
            keychainStore: store
        )
    }

    // MARK: - Tests

    @Test
    func `It should be logged in after setting the access token`() async {
        // Given
        let initialState = await service.isLoggedIn
        #expect(!initialState, "Should start as logged out")

        // When
        await service.setAccessToken("1b302f5c-157a-4caf-b450-8e1f7cde01ab")

        // Then
        let finalState = await service.isLoggedIn

        #expect(
            finalState,
            "It should be logged in after setting token"
        )

        #expect(
            fakeKeychainStore.wrappedValue == "1b302f5c-157a-4caf-b450-8e1f7cde01ab",
            "It should store the correct access token"
        )
    }

    @Test
    func `It should be logged out after clearing the access token`() async {
        // Given
        await service.setAccessToken("1b302f5c-157a-4caf-b450-8e1f7cde01ab")
        let loggedInState = await service.isLoggedIn

        #expect(
            loggedInState,
            "It should be logged in initially"
        )

        // When
        await service.setAccessToken(nil)

        // Then
        let loggedOutState = await service.isLoggedIn

        #expect(
            !loggedOutState,
            "it should be logged out after clearing token"
        )

        #expect(
            fakeKeychainStore.wrappedValue == nil,
            "It should clear out the access token"
        )
    }

    @Test
    func `It should yield the current login state when observing`() async throws {
        // Given
        let initialState = await service.isLoggedIn

        #expect(
            !initialState,
            "it should start logged out"
        )

        // When
        let stream = service.observeLoginState()

        // Then
        var iterator = stream.makeAsyncIterator()
        let nextValue = await iterator.next()
        let firstValue = try #require(nextValue as Bool?)

        #expect(
            firstValue == false,
            "It should yielded the first value correctly"
        )
    }
}
