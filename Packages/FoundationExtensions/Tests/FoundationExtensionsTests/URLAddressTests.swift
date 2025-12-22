import Foundation
import Testing
@testable import FoundationExtensions

@Suite("URLAddress Tests")
struct URLAddressTests {

    @Test("It should create webpage URL for OMG.LOL address")
    func webpageFor_withAddress_createsCorrectURL() {
        // Given
        let address = "alice"

        // When
        let url = URL(webpageFor: address)

        // Then
        #expect(
            url.absoluteString == "https://alice.omg.lol",
            "It should create webpage URL for OMG.LOL address"
        )
    }

    @Test("It should create now page URL for OMG.LOL address")
    func nowPageFor_withAddress_createsCorrectURL() {
        // Given
        let address = "bob"

        // When
        let url = URL(nowPageFor: address)

        // Then
        #expect(
            url.absoluteString == "https://bob.omg.lol/now",
            "It should create now page URL for OMG.LOL address"
        )
    }

    @Test("It should create weblog URL for OMG.LOL address")
    func weblogFor_withAddress_createsCorrectURL() {
        // Given
        let address = "charlie"

        // When
        let url = URL(weblogFor: address)

        // Then
        #expect(
            url.absoluteString == "https://charlie.weblog.lol",
            "It should create weblog URL for OMG.LOL address"
        )
    }

    @Test("It should create weblog post URL with location")
    func weblogPostFor_withAddressAndLocation_createsCorrectURL() {
        // Given
        let address = "dave"
        let location = "/my-post"

        // When
        let url = URL(weblogPostFor: address, location: location)

        // Then
        #expect(
            url.absoluteString == "https://dave.weblog.lol/my-post",
            "It should create weblog post URL with location"
        )
    }

    @Test("It should create avatar URL for OMG.LOL address")
    func avatarFor_withAddress_createsCorrectURL() {
        // Given
        let address = "eve"

        // When
        let url = URL(avatarFor: address)

        // Then
        #expect(
            url.absoluteString == "https://profiles.cache.lol/eve/picture",
            "It should create avatar URL for OMG.LOL address"
        )
    }

    @Test("It should create status URL with status ID and address")
    func statusID_withStatusIDAndAddress_createsCorrectURL() {
        // Given
        let statusID = "abc123"
        let address = "frank"

        // When
        let url = URL(statusID: statusID, for: address)

        // Then
        #expect(
            url.absoluteString == "https://frank.status.lol/abc123",
            "It should create status URL with status ID and address"
        )
    }

    @Test("It should create PURL URL with PURL name and address")
    func purlName_withPURLNameAndAddress_createsCorrectURL() {
        // Given
        let purlName = "github"
        let address = "grace"

        // When
        let url = URL(purlName: purlName, for: address)

        // Then
        #expect(
            url.absoluteString == "https://grace.url.lol/github",
            "It should create PURL URL with PURL name and address"
        )
    }

    @Test("It should create paste URL with paste title and address")
    func pasteTitle_withPasteTitleAndAddress_createsCorrectURL() {
        // Given
        let pasteTitle = "my-code"
        let address = "henry"

        // When
        let url = URL(pasteTitle: pasteTitle, for: address)

        // Then
        #expect(
            url.absoluteString == "https://henry.paste.lol/my-code",
            "It should create paste URL with paste title and address"
        )
    }

    @Test("It should create some.pics URL for OMG.LOL address")
    func somePicsFor_withAddress_createsCorrectURL() {
        // Given
        let address = "iris"

        // When
        let url = URL(somePicsFor: address)

        // Then
        #expect(
            url.absoluteString == "https://iris.some.pics",
            "It should create some.pics URL for OMG.LOL address"
        )
    }

    @Test("It should handle address with numbers")
    func webpageFor_withNumericAddress_createsCorrectURL() {
        // Given
        let address = "user123"

        // When
        let url = URL(webpageFor: address)

        // Then
        #expect(
            url.absoluteString == "https://user123.omg.lol",
            "It should handle address with numbers"
        )
    }

    @Test("It should handle address with hyphens")
    func webpageFor_withHyphenatedAddress_createsCorrectURL() {
        // Given
        let address = "user-name"

        // When
        let url = URL(webpageFor: address)

        // Then
        #expect(
            url.absoluteString == "https://user-name.omg.lol",
            "It should handle address with hyphens"
        )
    }

    @Test("It should handle weblog post location with path")
    func weblogPostFor_withPathLocation_createsCorrectURL() {
        // Given
        let address = "alice"
        let location = "/2024/01/my-blog-post"

        // When
        let url = URL(weblogPostFor: address, location: location)

        // Then
        #expect(
            url.absoluteString == "https://alice.weblog.lol/2024/01/my-blog-post",
            "It should handle weblog post location with path"
        )
    }

    @Test("It should handle status ID with special characters")
    func statusID_withSpecialCharacters_createsCorrectURL() {
        // Given
        let statusID = "abc-123_xyz"
        let address = "bob"

        // When
        let url = URL(statusID: statusID, for: address)

        // Then
        #expect(
            url.absoluteString == "https://bob.status.lol/abc-123_xyz",
            "It should handle status ID with special characters"
        )
    }

    @Test("It should handle PURL name with special characters")
    func purlName_withSpecialCharacters_createsCorrectURL() {
        // Given
        let purlName = "my-purl_name"
        let address = "charlie"

        // When
        let url = URL(purlName: purlName, for: address)

        // Then
        #expect(
            url.absoluteString == "https://charlie.url.lol/my-purl_name",
            "It should handle PURL name with special characters"
        )
    }

    @Test("It should handle paste title with special characters")
    func pasteTitle_withSpecialCharacters_createsCorrectURL() {
        // Given
        let pasteTitle = "my-code-snippet"
        let address = "dave"

        // When
        let url = URL(pasteTitle: pasteTitle, for: address)

        // Then
        #expect(
            url.absoluteString == "https://dave.paste.lol/my-code-snippet",
            "It should handle paste title with special characters"
        )
    }

    @Test("It should create nowGardenURL static property")
    func nowGardenURL_returnsCorrectURL() {
        // When
        let url = URL.nowGardenURL

        // Then
        #expect(
            url.absoluteString == "https://now.garden/",
            "It should create nowGardenURL static property"
        )
    }

    @Test("It should handle empty weblog location")
    func weblogPostFor_withEmptyLocation_createsCorrectURL() {
        // Given
        let address = "eve"
        let location = ""

        // When
        let url = URL(weblogPostFor: address, location: location)

        // Then
        #expect(
            url.absoluteString == "https://eve.weblog.lol",
            "It should handle empty weblog location"
        )
    }

    @Test("It should handle weblog location without leading slash")
    func weblogPostFor_withLocationWithoutSlash_createsCorrectURL() {
        // Given
        let address = "frank"
        let location = "/my-post"

        // When
        let url = URL(weblogPostFor: address, location: location)

        // Then
        #expect(
            url.absoluteString == "https://frank.weblog.lol/my-post",
            "It should handle weblog location without leading slash"
        )
    }
}
