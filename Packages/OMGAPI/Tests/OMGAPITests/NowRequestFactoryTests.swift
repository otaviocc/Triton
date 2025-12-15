import Testing
@testable import OMGAPI

@Suite("NowRequestFactory Tests")
struct NowRequestFactoryTests {

    @Test("It should create now page request with correct configuration")
    func makeNowRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = NowRequestFactory.makeNowRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/now",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create update now request with listed flag true")
    func makeUpdateNowRequest_withListedTrue_createsRequest() {
        // Given
        let address = "bob"
        let content = "Working on a new project"
        let listed = true

        // When
        let request = NowRequestFactory.makeUpdateNowRequest(
            address: address,
            content: content,
            listed: listed
        )

        // Then
        #expect(
            request.path == "/address/bob/now",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.content == content,
            "It should include content in request body"
        )

        #expect(
            request.body?.listed == 1,
            "It should convert listed true to 1 in request body"
        )
    }

    @Test("It should create update now request with listed flag false")
    func makeUpdateNowRequest_withListedFalse_createsRequest() {
        // Given
        let address = "charlie"
        let content = "Taking a break"
        let listed = false

        // When
        let request = NowRequestFactory.makeUpdateNowRequest(
            address: address,
            content: content,
            listed: listed
        )

        // Then
        #expect(
            request.path == "/address/charlie/now",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.content == content,
            "It should include content in request body"
        )

        #expect(
            request.body?.listed == 0,
            "It should convert listed false to 0 in request body"
        )
    }
}
