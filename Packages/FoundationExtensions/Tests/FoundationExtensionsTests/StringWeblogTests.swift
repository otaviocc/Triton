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

// swiftlint:disable file_length type_body_length identifier_name

import Foundation
import Testing
@testable import FoundationExtensions

struct StringWeblogTests {

    @Test
    func `It should create weblog entry body with frontmatter including date and status`() throws {
        // Given
        let content = "This is my blog post content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---

        This is my blog post content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should create weblog entry body with frontmatter including date and status"
        )
    }

    @Test
    func `It should include tags in frontmatter when tags are provided`() throws {
        // Given
        let content = "Blog post with tags"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags = ["swift", "ios", "development"]
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        Tags: swift, ios, development
        ---

        Blog post with tags
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should include tags in frontmatter when tags are provided"
        )
    }

    @Test
    func `It should not include tags line when tags array is empty`() throws {
        // Given
        let content = "Blog post without tags"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---

        Blog post without tags
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should not include tags line when tags array is empty"
        )
    }

    @Test
    func `It should format date correctly using ISO 8601 with short time`() throws {
        // Given
        let content = "Test content"
        let date = Date(timeIntervalSince1970: 1_704_153_600)
        let status = "Draft"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-02 00:00
        Status: Draft
        ---

        Test content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should format date correctly using ISO 8601 with short time"
        )
    }

    @Test
    func `It should handle different status values`() throws {
        // Given
        let content = "Test content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Feed Only"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Feed Only
        ---

        Test content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle different status values"
        )
    }

    @Test
    func `It should handle multiple tags with proper comma separation`() throws {
        // Given
        let content = "Multi-tag post"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags = ["tag1", "tag2", "tag3", "tag4"]
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        Tags: tag1, tag2, tag3, tag4
        ---

        Multi-tag post
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle multiple tags with proper comma separation"
        )
    }

    @Test
    func `It should handle single tag`() throws {
        // Given
        let content = "Single tag post"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags = ["swift"]
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        Tags: swift
        ---

        Single tag post
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle single tag"
        )
    }

    @Test
    func `It should preserve content exactly as provided`() throws {
        // Given
        let content = "This is my\nmultiline\nblog post content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---

        This is my
        multiline
        blog post content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should preserve content exactly as provided"
        )
    }

    @Test
    func `It should return UTF-8 encoded data`() throws {
        // Given
        let content = "Test content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            !resultString.isEmpty,
            "It should return UTF-8 encoded data"
        )
    }

    @Test
    func `It should handle empty content string`() throws {
        // Given
        let content = ""
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---


        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle empty content string"
        )
    }

    @Test
    func `It should handle tags with special characters`() throws {
        // Given
        let content = "Test content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags = ["swift-ios", "test@example", "tag_123"]
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        Tags: swift-ios, test@example, tag_123
        ---

        Test content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle tags with special characters"
        )
    }

    @Test
    func `It should handle unicode characters in content`() throws {
        // Given
        let content = "Café & Naïve résumé 🌟"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---

        Café & Naïve résumé 🌟
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle unicode characters in content"
        )
    }

    @Test
    func `It should have correct frontmatter structure`() throws {
        // Given
        let content = "Test content"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags = ["tag1", "tag2"]
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        Tags: tag1, tag2
        ---

        Test content
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should have correct frontmatter structure"
        )
    }

    @Test
    func `It should handle markdown content`() throws {
        // Given
        let content = "# Title\n\nThis is **bold** and *italic*"
        let date = Date(timeIntervalSince1970: 1_704_067_200)
        let status = "Live"
        let tags: [String] = []
        let expected = """
        ---
        Date: 2024-01-01 00:00
        Status: Live
        ---

        # Title

        This is **bold** and *italic*
        """

        // When
        let result = try content.weblogEntryBody(
            date: date,
            timeZone: #require(TimeZone(secondsFromGMT: 0)),
            status: status,
            tags: tags
        )

        // Then
        let resultString = try #require(
            String(data: result, encoding: .utf8)
        )

        #expect(
            resultString == expected,
            "It should handle markdown content"
        )
    }
}
