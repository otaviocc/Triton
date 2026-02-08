import Foundation
import Testing
@testable import FoundationExtensions

@Suite("URLMarkdown Tests")
struct URLMarkdownTests {

    @Test("It should return a markdown link with custom title")
    func markdownFormatted_withTitleAndDefaultIsImage_returnsMarkdownLink() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))
        let title = "Example Website"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        #expect(
            result == "[Example Website](https://example.com)",
            "It should return a markdown link with custom title"
        )
    }

    @Test("It should return a markdown link when isImage is explicitly false")
    func markdownFormatted_withTitleAndIsImageFalse_returnsMarkdownLink() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))
        let title = "Example Website"

        // When
        let result = url.markdownFormatted(title: title, isImage: false)

        // Then
        #expect(
            result == "[Example Website](https://example.com)",
            "It should return a markdown link when isImage is explicitly false"
        )
    }

    @Test("It should return a markdown image with custom alt text")
    func markdownFormatted_withTitleAndIsImageTrue_returnsMarkdownImage() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/image.jpg"))
        let title = "My Image"

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        #expect(
            result == "![My Image](https://example.com/image.jpg)",
            "It should return a markdown image with custom alt text"
        )
    }

    @Test("It should return a markdown link using URL as both title and link when no title provided")
    func markdownFormatted_withNoTitleAndDefaultIsImage_returnsMarkdownLinkWithURL() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))

        // When
        let result = url.markdownFormatted()

        // Then
        #expect(
            result == "[https://example.com](https://example.com)",
            "It should return a markdown link using URL as both title and link when no title provided"
        )
    }

    @Test("It should return a markdown image using URL as both alt text and source when no title provided")
    func markdownFormatted_withNoTitleAndIsImageTrue_returnsMarkdownImageWithURL() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/photo.png"))

        // When
        let result = url.markdownFormatted(isImage: true)

        // Then
        #expect(
            result == "![https://example.com/photo.png](https://example.com/photo.png)",
            "It should return a markdown image using URL as both alt text and source when no title provided"
        )
    }

    @Test("It should return a markdown link with empty title text when empty string provided")
    func markdownFormatted_withEmptyTitle_returnsMarkdownLinkWithURL() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))
        let title = ""

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        #expect(
            result == "[](https://example.com)",
            "It should return a markdown link with empty title text when empty string provided"
        )
    }

    @Test("It should return a markdown image with empty alt text when empty string provided")
    func markdownFormatted_withEmptyTitleAndIsImageTrue_returnsMarkdownImageWithEmptyAlt() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/image.gif"))
        let title = ""

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        #expect(
            result == "![](https://example.com/image.gif)",
            "It should return a markdown image with empty alt text when empty string provided"
        )
    }

    @Test("It should handle complex URLs with paths, queries, and fragments")
    func markdownFormatted_withComplexURL_returnsCorrectMarkdownLink() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/path/to/resource?query=value&other=param#section"))
        let title = "Complex URL"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        #expect(
            result == "[Complex URL](https://example.com/path/to/resource?query=value&other=param#section)",
            "It should handle complex URLs with paths, queries, and fragments"
        )
    }

    @Test("It should handle local file URLs correctly")
    func markdownFormatted_withLocalFileURL_returnsCorrectMarkdownLink() {
        // Given
        let url = URL(fileURLWithPath: "/Users/test/document.pdf")
        let title = "Local Document"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        #expect(
            result == "[Local Document](file:///Users/test/document.pdf)",
            "It should handle local file URLs correctly"
        )
    }

    @Test("It should preserve special characters in title without escaping")
    func markdownFormatted_withSpecialCharactersInTitle_returnsMarkdownLinkWithSpecialChars() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))
        let title = "Special [Characters] & Symbols"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        #expect(
            result == "[Special [Characters] & Symbols](https://example.com)",
            "It should preserve special characters in title without escaping"
        )
    }

    @Test("It should handle unicode characters and emojis in title correctly")
    func markdownFormatted_withUnicodeInTitle_returnsMarkdownLinkWithUnicode() throws {
        // Given
        let url = try #require(URL(string: "https://example.com"))
        let title = "Café & Naïve résumé 🌟"

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        #expect(
            result == "![Café & Naïve résumé 🌟](https://example.com)",
            "It should handle unicode characters and emojis in title correctly"
        )
    }
}
