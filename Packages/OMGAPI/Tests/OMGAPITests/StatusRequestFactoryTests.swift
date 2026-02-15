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

import Testing
@testable import OMGAPI

@Suite("StatusRequestFactory Tests")
struct StatusRequestFactoryTests {

    @Test("It should create all statuses request with correct configuration")
    func makeAllStatusesRequest_createsRequest() {
        // When
        let request = StatusRequestFactory.makeAllStatusesRequest()

        // Then
        #expect(
            request.path == "/statuslog",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create latest statuses request with correct configuration")
    func makeLatestStatusesRequest_createsRequest() {
        // When
        let request = StatusRequestFactory.makeLatestStatusesRequest()

        // Then
        #expect(
            request.path == "/statuslog/latest",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create address statuses request with correct configuration")
    func makeAddressStatusesRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = StatusRequestFactory.makeAddressStatusesRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/statuses/",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create address bio request with correct configuration")
    func makeAddressBioRequest_createsRequest() {
        // Given
        let address = "bob"

        // When
        let request = StatusRequestFactory.makeAddressBioRequest(address: address)

        // Then
        #expect(
            request.path == "/address/bob/statuses/bio",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create share status request with correct configuration")
    func makeShareStatusRequest_createsRequest() {
        // Given
        let address = "charlie"
        let emoji = "🎉"
        let content = "Testing status update"

        // When
        let request = StatusRequestFactory.makeShareStatusRequest(
            address: address,
            emoji: emoji,
            content: content
        )

        // Then
        #expect(
            request.path == "/address/charlie/statuses",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.emoji == emoji,
            "It should include emoji in request body"
        )

        #expect(
            request.body?.content == content,
            "It should include content in request body"
        )
    }

    @Test("It should create individual status request with correct configuration")
    func makeIndividualStatusRequest_createsRequest() {
        // Given
        let address = "dave"
        let statusID = "status_123"

        // When
        let request = StatusRequestFactory.makeIndividualStatusRequest(
            address: address,
            statusID: statusID
        )

        // Then
        #expect(
            request.path == "/address/dave/statuses/status_123",
            "It should use correct API path with address and status ID"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }
}
