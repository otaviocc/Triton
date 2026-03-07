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

struct WebpageRequestFactoryTests {

    @Test
    func `It should create webpage request with correct configuration`() {
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

    @Test
    func `It should create update webpage request with publish true`() {
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

    @Test
    func `It should create update webpage request with publish false`() {
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
