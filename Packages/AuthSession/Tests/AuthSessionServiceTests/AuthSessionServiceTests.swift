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

    func testObserveLoginStateYieldsCurrentState() async {
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

        XCTAssertEqual(
            firstValue,
            false,
            "It should yielded the first value correctly"
        )
    }
}
