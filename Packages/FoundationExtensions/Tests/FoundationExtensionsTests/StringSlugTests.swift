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

struct StringSlugTests {

    @Test
    func `It should convert simple string with space to slug format`() {
        // Given
        let input = "Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should convert simple string with space to slug format"
        )
    }

    @Test
    func `It should trim leading and trailing whitespace`() {
        // Given
        let input = "  multiple   spaces  "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "multiple-spaces",
            "It should trim leading and trailing whitespace"
        )
    }

    @Test
    func `It should handle already slugged strings`() {
        // Given
        let input = "already-slugged"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "already-slugged",
            "It should handle already slugged strings"
        )
    }

    @Test
    func `It should handle multiple consecutive spaces`() {
        // Given
        let input = "multiple    spaces    here"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "multiple-spaces-here",
            "It should handle multiple consecutive spaces"
        )
    }

    @Test
    func `It should handle tabs and newlines as whitespace`() {
        // Given
        let input = "hello\tworld\nhere"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "hello-world-here",
            "It should handle tabs and newlines as whitespace"
        )
    }

    @Test
    func `It should handle empty string`() {
        // Given
        let input = ""

        // When
        let result = input.slugified()

        // Then
        #expect(
            result.isEmpty,
            "It should handle empty string"
        )
    }

    @Test
    func `It should handle string with only whitespace`() {
        // Given
        let input = "   \t\n   "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result.isEmpty,
            "It should handle string with only whitespace"
        )
    }

    @Test
    func `It should handle single word`() {
        // Given
        let input = "Hello"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello",
            "It should handle single word"
        )
    }

    @Test
    func `It should preserve special characters in words`() {
        // Given
        let input = "test@email.com user123"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "test@email.com-user123",
            "It should preserve special characters in words"
        )
    }

    @Test
    func `It should handle unicode characters`() {
        // Given
        let input = "café naïve résumé"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "café-naïve-résumé",
            "It should handle unicode characters"
        )
    }

    @Test
    func `It should handle emoji characters`() {
        // Given
        let input = "Hello 👋 World 🌟"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-👋-World-🌟",
            "It should handle emoji characters"
        )
    }

    @Test
    func `It should handle mixed case strings`() {
        // Given
        let input = "Hello World Test"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World-Test",
            "It should handle mixed case strings"
        )
    }

    @Test
    func `It should handle string starting with whitespace`() {
        // Given
        let input = "   Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string starting with whitespace"
        )
    }

    @Test
    func `It should handle string ending with whitespace`() {
        // Given
        let input = "Hello World   "

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string ending with whitespace"
        )
    }

    @Test
    func `It should handle string with single space`() {
        // Given
        let input = "Hello World"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "Hello-World",
            "It should handle string with single space"
        )
    }

    @Test
    func `It should handle numbers in string`() {
        // Given
        let input = "test 123 456"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "test-123-456",
            "It should handle numbers in string"
        )
    }

    @Test
    func `It should handle punctuation in words`() {
        // Given
        let input = "hello-world test.com"

        // When
        let result = input.slugified()

        // Then
        #expect(
            result == "hello-world-test.com",
            "It should handle punctuation in words"
        )
    }
}
