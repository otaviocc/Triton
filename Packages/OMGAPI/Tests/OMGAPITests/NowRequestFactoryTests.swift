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

struct NowRequestFactoryTests {

    @Test
    func `It should create now page request with correct configuration`() {
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

    @Test
    func `It should create update now request with listed flag true`() {
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

    @Test
    func `It should create update now request with listed flag false`() {
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
