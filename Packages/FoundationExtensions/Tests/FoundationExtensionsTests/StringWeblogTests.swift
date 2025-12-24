import Foundation
import Testing
@testable import FoundationExtensions

@Suite("StringWeblog Tests")
struct StringWeblogTests {

    @Test("It should create weblog entry body with frontmatter including date and status")
    func weblogEntryBody_withDateAndStatus_createsFrontmatter() throws {
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

    @Test("It should include tags in frontmatter when tags are provided")
    func weblogEntryBody_withTags_includesTagsInFrontmatter() throws {
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

    @Test("It should not include tags line when tags array is empty")
    func weblogEntryBody_withEmptyTags_omitsTagsLine() throws {
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

    @Test("It should format date correctly using ISO 8601 with short time")
    func weblogEntryBody_withSpecificDate_formatsDateCorrectly() throws {
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

    @Test("It should handle different status values")
    func weblogEntryBody_withDifferentStatus_includesStatus() throws {
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

    @Test("It should handle multiple tags with proper comma separation")
    func weblogEntryBody_withMultipleTags_separatesWithCommas() throws {
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

    @Test("It should handle single tag")
    func weblogEntryBody_withSingleTag_includesTag() throws {
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

    @Test("It should preserve content exactly as provided")
    func weblogEntryBody_withContent_preservesContent() throws {
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

    @Test("It should return UTF-8 encoded data")
    func weblogEntryBody_returnsUTF8EncodedData() throws {
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

    @Test("It should handle empty content string")
    func weblogEntryBody_withEmptyContent_includesEmptyContent() throws {
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

    @Test("It should handle tags with special characters")
    func weblogEntryBody_withSpecialCharacterTags_preservesCharacters() throws {
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

    @Test("It should handle unicode characters in content")
    func weblogEntryBody_withUnicodeContent_preservesUnicode() throws {
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

    @Test("It should have correct frontmatter structure")
    func weblogEntryBody_hasCorrectFrontmatterStructure() throws {
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

    @Test("It should handle markdown content")
    func weblogEntryBody_withMarkdownContent_preservesMarkdown() throws {
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
