import Foundation
import Testing
@testable import OMGAPI

@Suite("WeblogRequestFactory Tests")
struct WeblogRequestFactoryTests {

    @Test("It should create all entries request with correct configuration")
    func makeAllEntriesRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = WeblogRequestFactory.makeAllEntriesRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/weblog/entries",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create individual entry request with correct configuration")
    func makeWeblogIndividualEntryRequest_createsRequest() {
        // Given
        let address = "bob"
        let entryID = "my-blog-post"

        // When
        let request = WeblogRequestFactory.makeWeblogIndividualEntryRequest(
            address: address,
            entryID: entryID
        )

        // Then
        #expect(
            request.path == "/address/bob/weblog/entry/my-blog-post",
            "It should use correct API path with address and entry ID"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create weblog entry creation request with correct configuration")
    func makeCreateWeblogEntryRequest_createsRequest() {
        // Given
        let address = "charlie"
        let content = "This is my first blog post!"
        let status = "Live"
        let tags: [String] = []
        let date = Date(timeIntervalSince1970: 1_704_067_200) // 2024-01-01

        // When
        let request = WeblogRequestFactory.makeCreateWeblogEntryRequest(
            address: address,
            content: content,
            status: status,
            tags: tags,
            date: date
        )

        // Then
        #expect(
            request.path == "/address/charlie/weblog/entry",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body != nil,
            "It should include request body with formatted content"
        )
    }

    @Test("It should create weblog entry update request with correct configuration")
    func makeUpdateWeblogEntryRequest_createsRequest() {
        // Given
        let address = "dave"
        let entryID = "updated-post"
        let content = "This is an updated blog post!"
        let status = "Live"
        let tags: [String] = []
        let date = Date(timeIntervalSince1970: 1_704_153_600) // 2024-01-02

        // When
        let request = WeblogRequestFactory.makeUpdateWeblogEntryRequest(
            address: address,
            entryID: entryID,
            content: content,
            status: status,
            tags: tags,
            date: date
        )

        // Then
        #expect(
            request.path == "/address/dave/weblog/entry/updated-post",
            "It should use correct API path with address and entry ID"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body != nil,
            "It should include request body with formatted content"
        )
    }

    @Test("It should create weblog entry deletion request with correct configuration")
    func makeDeleteWeblogEntryRequest_createsRequest() {
        // Given
        let address = "eve"
        let entryID = "post-to-delete"

        // When
        let request = WeblogRequestFactory.makeDeleteWeblogEntryRequest(
            address: address,
            entryID: entryID
        )

        // Then
        #expect(
            request.path == "/address/eve/weblog/delete/post-to-delete",
            "It should use correct API path with address and entry ID"
        )

        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }
}
