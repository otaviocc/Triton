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

struct OMGAPIFactoryTests {

    @Test
    func `It should create a properly configured network client`() {
        // Given
        let factory = OMGAPIFactory()
        let expectedToken = "test_token_123"

        // When
        let client = factory.makeOMGAPIClient {
            expectedToken
        }

        // Then
        let clientType = type(of: client)
        #expect(
            String(describing: clientType) == "NetworkClient",
            "It should create a NetworkClient instance"
        )
    }

    @Test
    func `It should create a network client with nil token provider`() {
        // Given
        let factory = OMGAPIFactory()

        // When
        let client = factory.makeOMGAPIClient {
            nil
        }

        // Then
        let clientType = type(of: client)
        #expect(
            String(describing: clientType) == "NetworkClient",
            "It should create a NetworkClient instance even with nil token"
        )
    }
}
