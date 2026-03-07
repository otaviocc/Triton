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

import Testing
@testable import OMGAPI

struct PastebinRequestFactoryTests {

    @Test
    func `It should create pastes request with correct configuration`() {
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

    @Test
    func `It should create paste creation request with listed true`() {
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

    @Test
    func `It should create paste creation request with listed false`() {
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

    @Test
    func `It should create paste deletion request with correct configuration`() {
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
