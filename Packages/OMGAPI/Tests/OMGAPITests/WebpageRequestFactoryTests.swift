import Testing
@testable import OMGAPI

@Suite("WebpageRequestFactory Tests")
struct WebpageRequestFactoryTests {

    @Test("It should create webpage request with correct configuration")
    func makeWebpageRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = WebpageRequestFactory.makeWebpageRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/web",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create update webpage request with publish true")
    func makeUpdateWebpageRequest_withPublishTrue_createsRequest() {
        // Given
        let address = "bob"
        let content = "<h1>Welcome to Bob's Page</h1>"
        let publish = true

        // When
        let request = WebpageRequestFactory.makeUpdateWebpageRequest(
            address: address,
            content: content,
            publish: publish
        )

        // Then
        #expect(
            request.path == "/address/bob/web",
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
            request.body?.publish == true,
            "It should include publish flag as true in request body"
        )
    }

    @Test("It should create update webpage request with publish false")
    func makeUpdateWebpageRequest_withPublishFalse_createsRequest() {
        // Given
        let address = "charlie"
        let content = "<h1>Draft Page</h1>"
        let publish = false

        // When
        let request = WebpageRequestFactory.makeUpdateWebpageRequest(
            address: address,
            content: content,
            publish: publish
        )

        // Then
        #expect(
            request.path == "/address/charlie/web",
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
            request.body?.publish == false,
            "It should include publish flag as false in request body"
        )
    }
}
