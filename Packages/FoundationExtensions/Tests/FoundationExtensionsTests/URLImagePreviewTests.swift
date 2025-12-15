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
            "It should insert .preview before the file extension"
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
            "https://example.com/photos/sunset.preview.png",
            "It should insert .preview before PNG extension"
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
            "https://example.com/images/photo.preview",
            "It should append .preview when there is no file extension"
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
            "https://cdn.example.com/user-uploads/my-vacation-photo.preview.jpeg",
            "It should handle complex filenames with hyphens"
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
            "It should preserve query parameters in the preview URL"
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
            "https://storage.example.com/users/123/albums/vacation/beach.preview.gif",
            "It should maintain the full directory structure"
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
            "/Users/test/Documents/screenshot.preview.png",
            "It should work with local file URLs"
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
            "It should insert .preview before the last extension when multiple dots exist"
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
            "It should handle single character filenames"
        )
    }
}
