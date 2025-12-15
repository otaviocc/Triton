import XCTest
@testable import FoundationExtensions

final class URLMarkdownTests: XCTestCase {

    func test_markdownFormatted_withTitleAndDefaultIsImage_returnsMarkdownLink() {
        // Given
        let url = URL(string: "https://example.com")!
        let title = "Example Website"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        XCTAssertEqual(
            result,
            "[Example Website](https://example.com)",
            "It should return a markdown link with custom title"
        )
    }

    func test_markdownFormatted_withTitleAndIsImageFalse_returnsMarkdownLink() {
        // Given
        let url = URL(string: "https://example.com")!
        let title = "Example Website"

        // When
        let result = url.markdownFormatted(title: title, isImage: false)

        // Then
        XCTAssertEqual(
            result,
            "[Example Website](https://example.com)",
            "It should return a markdown link when isImage is explicitly false"
        )
    }

    func test_markdownFormatted_withTitleAndIsImageTrue_returnsMarkdownImage() {
        // Given
        let url = URL(string: "https://example.com/image.jpg")!
        let title = "My Image"

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        XCTAssertEqual(
            result,
            "![My Image](https://example.com/image.jpg)",
            "It should return a markdown image with custom alt text"
        )
    }

    func test_markdownFormatted_withNoTitleAndDefaultIsImage_returnsMarkdownLinkWithURL() {
        // Given
        let url = URL(string: "https://example.com")!

        // When
        let result = url.markdownFormatted()

        // Then
        XCTAssertEqual(
            result,
            "[https://example.com](https://example.com)",
            "It should return a markdown link using URL as both title and link when no title provided"
        )
    }

    func test_markdownFormatted_withNoTitleAndIsImageTrue_returnsMarkdownImageWithURL() {
        // Given
        let url = URL(string: "https://example.com/photo.png")!

        // When
        let result = url.markdownFormatted(isImage: true)

        // Then
        XCTAssertEqual(
            result,
            "![https://example.com/photo.png](https://example.com/photo.png)",
            "It should return a markdown image using URL as both alt text and source when no title provided"
        )
    }

    func test_markdownFormatted_withEmptyTitle_returnsMarkdownLinkWithURL() {
        // Given
        let url = URL(string: "https://example.com")!
        let title = ""

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        XCTAssertEqual(
            result,
            "[](https://example.com)",
            "It should return a markdown link with empty title text when empty string provided"
        )
    }

    func test_markdownFormatted_withEmptyTitleAndIsImageTrue_returnsMarkdownImageWithEmptyAlt() {
        // Given
        let url = URL(string: "https://example.com/image.gif")!
        let title = ""

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        XCTAssertEqual(
            result,
            "![](https://example.com/image.gif)",
            "It should return a markdown image with empty alt text when empty string provided"
        )
    }

    func test_markdownFormatted_withComplexURL_returnsCorrectMarkdownLink() {
        // Given
        let url = URL(string: "https://example.com/path/to/resource?query=value&other=param#section")!
        let title = "Complex URL"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        XCTAssertEqual(
            result,
            "[Complex URL](https://example.com/path/to/resource?query=value&other=param#section)",
            "It should handle complex URLs with paths, queries, and fragments"
        )
    }

    func test_markdownFormatted_withLocalFileURL_returnsCorrectMarkdownLink() {
        // Given
        let url = URL(fileURLWithPath: "/Users/test/document.pdf")
        let title = "Local Document"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        XCTAssertEqual(
            result,
            "[Local Document](file:///Users/test/document.pdf)",
            "It should handle local file URLs correctly"
        )
    }

    func test_markdownFormatted_withSpecialCharactersInTitle_returnsMarkdownLinkWithSpecialChars() {
        // Given
        let url = URL(string: "https://example.com")!
        let title = "Special [Characters] & Symbols"

        // When
        let result = url.markdownFormatted(title: title)

        // Then
        XCTAssertEqual(
            result,
            "[Special [Characters] & Symbols](https://example.com)",
            "It should preserve special characters in title without escaping"
        )
    }

    func test_markdownFormatted_withUnicodeInTitle_returnsMarkdownLinkWithUnicode() {
        // Given
        let url = URL(string: "https://example.com")!
        let title = "Café & Naïve résumé 🌟"

        // When
        let result = url.markdownFormatted(title: title, isImage: true)

        // Then
        XCTAssertEqual(
            result,
            "![Café & Naïve résumé 🌟](https://example.com)",
            "It should handle unicode characters and emojis in title correctly"
        )
    }
}
