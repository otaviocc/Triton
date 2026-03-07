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

struct PURLsRequestFactoryTests {

    @Test
    func `It should create all PURLs request with correct configuration`() {
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

    @Test
    func `It should create PURL creation request with correct configuration`() {
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

    @Test
    func `It should create PURL deletion request with correct configuration`() {
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
