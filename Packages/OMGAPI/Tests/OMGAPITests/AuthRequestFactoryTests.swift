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
@testable import OMGAPI

struct AuthRequestFactoryTests {

    @Test
    func `It should create OAuth authorization URL with correct parameters`() throws {
        // When
        let url = try #require(
            AuthRequestFactory.makeOAuthCodeRequestURL(),
            "It should create a non-nil URL"
        )

        let components = try #require(
            URLComponents(url: url, resolvingAgainstBaseURL: true),
            "It should create valid URL components"
        )

        // Then
        #expect(
            components.scheme == "https",
            "It should use HTTPS scheme"
        )

        #expect(
            components.host == "home.omg.lol",
            "It should use correct host"
        )

        #expect(
            components.path == "/oauth/authorize",
            "It should use correct path"
        )

        let queryItems = try #require(
            components.queryItems,
            "It should have query items"
        )

        #expect(
            queryItems.contains { $0.name == "client_id" },
            "It should include client_id parameter"
        )

        #expect(
            queryItems.contains { $0.name == "scope" && $0.value == "everything" },
            "It should include scope parameter with 'everything' value"
        )

        #expect(
            queryItems.contains { $0.name == "response_type" && $0.value == "code" },
            "It should include response_type parameter with 'code' value"
        )

        #expect(
            queryItems.contains { $0.name == "redirect_uri" },
            "It should include redirect_uri parameter"
        )
    }

    @Test
    func `It should create auth request with correct configuration`() {
        // Given
        let authCode = "test_auth_code_123"

        // When
        let request = AuthRequestFactory.makeAuthRequest(code: authCode)

        // Then
        #expect(
            request.path == "/oauth",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )

        let queryItems = request.queryItems

        #expect(
            queryItems.contains { $0.name == "client_id" },
            "It should include client_id query parameter"
        )

        #expect(
            queryItems.contains { $0.name == "client_secret" },
            "It should include client_secret query parameter"
        )

        #expect(
            queryItems.contains { $0.name == "redirect_uri" },
            "It should include redirect_uri query parameter"
        )

        #expect(
            queryItems.contains { $0.name == "code" && $0.value == authCode },
            "It should include code query parameter with provided auth code"
        )

        #expect(
            queryItems.contains { $0.name == "scope" && $0.value == "everything" },
            "It should include scope query parameter"
        )
    }
}
