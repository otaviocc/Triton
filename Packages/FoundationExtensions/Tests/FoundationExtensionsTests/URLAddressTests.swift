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

import Foundation
import Testing
@testable import FoundationExtensions

struct URLAddressTests {

    @Test
    func `It should create webpage URL for OMG.LOL address`() {
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

    @Test
    func `It should create now page URL for OMG.LOL address`() {
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

    @Test
    func `It should create weblog URL for OMG.LOL address`() {
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

    @Test
    func `It should create weblog post URL with location`() {
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

    @Test
    func `It should create avatar URL for OMG.LOL address`() {
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

    @Test
    func `It should create status URL with status ID and address`() {
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

    @Test
    func `It should create PURL URL with PURL name and address`() {
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

    @Test
    func `It should create paste URL with paste title and address`() {
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

    @Test
    func `It should create some.pics URL for OMG.LOL address`() {
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

    @Test
    func `It should handle address with numbers`() {
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

    @Test
    func `It should handle address with hyphens`() {
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

    @Test
    func `It should handle weblog post location with path`() {
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

    @Test
    func `It should handle status ID with special characters`() {
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

    @Test
    func `It should handle PURL name with special characters`() {
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

    @Test
    func `It should handle paste title with special characters`() {
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

    @Test
    func `It should create nowGardenURL static property`() {
        // When
        let url = URL.nowGardenURL

        // Then
        #expect(
            url.absoluteString == "https://now.garden/",
            "It should create nowGardenURL static property"
        )
    }

    @Test
    func `It should handle empty weblog location`() {
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

    @Test
    func `It should handle weblog location without leading slash`() {
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
