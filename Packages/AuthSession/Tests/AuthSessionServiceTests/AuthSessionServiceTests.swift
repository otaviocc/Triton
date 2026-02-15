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

import AuthSessionServiceInterface
import XCTest
@testable import AuthSessionService

final class AuthSessionServiceTests: XCTestCase {

    // MARK: - Properties

    private var service: (any AuthSessionServiceProtocol)!
    private var fakeKeychainStore: KeychainStoreProtocol!

    // MARK: - Lifecycle

    override func setUp() async throws {
        try await super.setUp()

        let store = KeychainStoreMother.makeKeychainStore()
        fakeKeychainStore = store

        service = AuthSessionService(
            keychainStore: store
        )
    }

    override func tearDown() async throws {
        service = nil
        fakeKeychainStore = nil

        try await super.tearDown()
    }

    // MARK: - Tests

    func testAccessTokenSignIn() async {
        // Given
        let initialState = await service.isLoggedIn
        XCTAssertFalse(initialState, "Should start as logged out")

        // When
        await service.setAccessToken("1b302f5c-157a-4caf-b450-8e1f7cde01ab")

        // Then
        let finalState = await service.isLoggedIn

        XCTAssertTrue(
            finalState,
            "It should be logged in after setting token"
        )

        XCTAssertEqual(
            fakeKeychainStore.wrappedValue,
            "1b302f5c-157a-4caf-b450-8e1f7cde01ab",
            "It should store the correct access token"
        )
    }

    func testAccessTokenSignOut() async {
        // Given
        await service.setAccessToken("1b302f5c-157a-4caf-b450-8e1f7cde01ab")
        let loggedInState = await service.isLoggedIn

        XCTAssertTrue(
            loggedInState,
            "It should be logged in initially"
        )

        // When
        await service.setAccessToken(nil)

        // Then
        let loggedOutState = await service.isLoggedIn

        XCTAssertFalse(
            loggedOutState,
            "it should be logged out after clearing token"
        )

        XCTAssertNil(
            fakeKeychainStore.wrappedValue,
            "It should clear out the access token"
        )
    }

    func testObserveLoginStateYieldsCurrentState() async throws {
        // Given
        let initialState = await service.isLoggedIn

        XCTAssertFalse(
            initialState,
            "it should start logged out"
        )

        // When
        let stream = service.observeLoginState()

        // Then
        var iterator = stream.makeAsyncIterator()
        let firstValue = await iterator.next()

        XCTAssertFalse(
            try XCTUnwrap(firstValue),
            "It should yielded the first value correctly"
        )
    }
}
