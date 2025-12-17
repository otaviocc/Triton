import XCTest
@testable import FoundationExtensions

final class URLImagePreviewTests: XCTestCase {

    func test_imagePreviewURL_withStandardImageURL_insertsPreviewBeforeExtension() {
        // Given
        let url = URL(string: "https://cdn.some.pics/user/image.jpg")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://cdn.some.pics/user/image.preview.jpg",
            "It should replace the file extension with .preview.jpg"
        )
    }

    func test_imagePreviewURL_withPNGImage_insertsPreviewBeforeExtension() {
        // Given
        let url = URL(string: "https://example.com/photos/sunset.png")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://example.com/photos/sunset.preview.jpg",
            "It should replace PNG extension with .preview.jpg"
        )
    }

    func test_imagePreviewURL_withNoExtension_appendsPreview() {
        // Given
        let url = URL(string: "https://example.com/images/photo")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://example.com/images/photo.preview.jpg",
            "It should append .preview.jpg when there is no file extension"
        )
    }

    func test_imagePreviewURL_withComplexFilename_insertsPreviewCorrectly() {
        // Given
        let url = URL(string: "https://cdn.example.com/user-uploads/my-vacation-photo.jpeg")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://cdn.example.com/user-uploads/my-vacation-photo.preview.jpg",
            "It should replace the extension with .preview.jpg for complex filenames"
        )
    }

    func test_imagePreviewURL_withQueryParameters_preservesQuery() {
        // Given
        let url = URL(string: "https://api.example.com/images/photo.jpg?size=large&quality=high")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://api.example.com/images/photo.preview.jpg?size=large&quality=high",
            "It should preserve query parameters and use .preview.jpg extension"
        )
    }

    func test_imagePreviewURL_withNestedDirectories_maintainsDirectoryStructure() {
        // Given
        let url = URL(string: "https://storage.example.com/users/123/albums/vacation/beach.gif")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://storage.example.com/users/123/albums/vacation/beach.preview.jpg",
            "It should maintain the full directory structure and use .preview.jpg extension"
        )
    }

    func test_imagePreviewURL_withLocalFileURL_insertsPreviewCorrectly() {
        // Given
        let url = URL(fileURLWithPath: "/Users/test/Documents/screenshot.png")

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.path,
            "/Users/test/Documents/screenshot.preview.jpg",
            "It should work with local file URLs and use .preview.jpg extension"
        )
    }

    func test_imagePreviewURL_withMultipleDots_insertsPreviewBeforeLastExtension() {
        // Given
        let url = URL(string: "https://example.com/files/image.backup.jpg")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://example.com/files/image.backup.preview.jpg",
            "It should replace the last extension with .preview.jpg when multiple dots exist"
        )
    }

    func test_imagePreviewURL_withSingleCharacterFilename_insertsPreviewCorrectly() {
        // Given
        let url = URL(string: "https://example.com/a.jpg")!

        // When
        let result = url.imagePreviewURL

        // Then
        XCTAssertEqual(
            result.absoluteString,
            "https://example.com/a.preview.jpg",
            "It should handle single character filenames and use .preview.jpg extension"
        )
    }
}
