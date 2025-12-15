import Testing
@testable import OMGAPI

@Suite("PURLsRequestFactory Tests")
struct PURLsRequestFactoryTests {

    @Test("It should create all PURLs request with correct configuration")
    func makeAllPURLsRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = PURLsRequestFactory.makeAllPURLsRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/purls",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create PURL creation request with correct configuration")
    func makeCreatePURLRequest_createsRequest() {
        // Given
        let address = "bob"
        let name = "blog"
        let url = "https://example.com/blog"

        // When
        let request = PURLsRequestFactory.makeCreatePURLRequest(
            address: address,
            name: name,
            url: url
        )

        // Then
        #expect(
            request.path == "/address/bob/purl",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.address == address,
            "It should include address in request body"
        )

        #expect(
            request.body?.name == name,
            "It should include name in request body"
        )

        #expect(
            request.body?.url == url,
            "It should include url in request body"
        )
    }

    @Test("It should create PURL deletion request with correct configuration")
    func makeDeletePURLRequest_createsRequest() {
        // Given
        let address = "charlie"
        let name = "portfolio"

        // When
        let request = PURLsRequestFactory.makeDeletePURLRequest(
            address: address,
            name: name
        )

        // Then
        #expect(
            request.path == "/address/charlie/purl/portfolio",
            "It should use correct API path with address and PURL name"
        )

        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }
}
