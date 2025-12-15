import Testing
@testable import OMGAPI

@Suite("PastebinRequestFactory Tests")
struct PastebinRequestFactoryTests {

    @Test("It should create pastes request with correct configuration")
    func makePastesRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = PastebinRequestFactory.makePastesRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/pastebin",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create paste creation request with listed true")
    func makeCreateOrUpdatePasteRequest_withListedTrue_createsRequest() {
        // Given
        let address = "bob"
        let title = "config-example"
        let content = "server = localhost\nport = 8080"
        let isListed = true

        // When
        let request = PastebinRequestFactory.makeCreateOrUpdatePasteRequest(
            address: address,
            title: title,
            content: content,
            isListed: isListed
        )

        // Then
        #expect(
            request.path == "/address/bob/pastebin",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.title == title,
            "It should include title in request body"
        )

        #expect(
            request.body?.content == content,
            "It should include content in request body"
        )

        #expect(
            request.body?.listed == true,
            "It should include listed flag as true in request body"
        )
    }

    @Test("It should create paste creation request with listed false")
    func makeCreateOrUpdatePasteRequest_withListedFalse_createsRequest() {
        // Given
        let address = "charlie"
        let title = "private-notes"
        let content = "These are my private notes"
        let isListed = false

        // When
        let request = PastebinRequestFactory.makeCreateOrUpdatePasteRequest(
            address: address,
            title: title,
            content: content,
            isListed: isListed
        )

        // Then
        #expect(
            request.path == "/address/charlie/pastebin",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.title == title,
            "It should include title in request body"
        )

        #expect(
            request.body?.content == content,
            "It should include content in request body"
        )

        #expect(
            request.body?.listed == false,
            "It should include listed flag as false in request body"
        )
    }

    @Test("It should create paste deletion request with correct configuration")
    func makeDeletePasteRequest_createsRequest() {
        // Given
        let address = "dave"
        let title = "old-snippet"

        // When
        let request = PastebinRequestFactory.makeDeletePasteRequest(
            address: address,
            title: title
        )

        // Then
        #expect(
            request.path == "/address/dave/pastebin/old-snippet",
            "It should use correct API path with address and paste title"
        )

        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }
}
