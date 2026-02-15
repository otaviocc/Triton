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

import Foundation
import Testing
@testable import FoundationExtensions

@Suite("URLImagePreview Tests")
struct URLImagePreviewTests {

    @Test("It should replace the file extension with .preview.jpg")
    func imagePreviewURL_withStandardImageURL_insertsPreviewBeforeExtension() throws {
        // Given
        let url = try #require(URL(string: "https://cdn.some.pics/user/image.jpg"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://cdn.some.pics/user/image.preview.jpg",
            "It should replace the file extension with .preview.jpg"
        )
    }

    @Test("It should replace PNG extension with .preview.jpg")
    func imagePreviewURL_withPNGImage_insertsPreviewBeforeExtension() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/photos/sunset.png"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://example.com/photos/sunset.preview.jpg",
            "It should replace PNG extension with .preview.jpg"
        )
    }

    @Test("It should append .preview.jpg when there is no file extension")
    func imagePreviewURL_withNoExtension_appendsPreview() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/images/photo"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://example.com/images/photo.preview.jpg",
            "It should append .preview.jpg when there is no file extension"
        )
    }

    @Test("It should replace the extension with .preview.jpg for complex filenames")
    func imagePreviewURL_withComplexFilename_insertsPreviewCorrectly() throws {
        // Given
        let url = try #require(URL(string: "https://cdn.example.com/user-uploads/my-vacation-photo.jpeg"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://cdn.example.com/user-uploads/my-vacation-photo.preview.jpg",
            "It should replace the extension with .preview.jpg for complex filenames"
        )
    }

    @Test("It should preserve query parameters and use .preview.jpg extension")
    func imagePreviewURL_withQueryParameters_preservesQuery() throws {
        // Given
        let url = try #require(URL(string: "https://api.example.com/images/photo.jpg?size=large&quality=high"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://api.example.com/images/photo.preview.jpg?size=large&quality=high",
            "It should preserve query parameters and use .preview.jpg extension"
        )
    }

    @Test("It should maintain the full directory structure and use .preview.jpg extension")
    func imagePreviewURL_withNestedDirectories_maintainsDirectoryStructure() throws {
        // Given
        let url = try #require(URL(string: "https://storage.example.com/users/123/albums/vacation/beach.gif"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://storage.example.com/users/123/albums/vacation/beach.preview.jpg",
            "It should maintain the full directory structure and use .preview.jpg extension"
        )
    }

    @Test("It should work with local file URLs and use .preview.jpg extension")
    func imagePreviewURL_withLocalFileURL_insertsPreviewCorrectly() {
        // Given
        let url = URL(fileURLWithPath: "/Users/test/Documents/screenshot.png")

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.path == "/Users/test/Documents/screenshot.preview.jpg",
            "It should work with local file URLs and use .preview.jpg extension"
        )
    }

    @Test("It should replace the last extension with .preview.jpg when multiple dots exist")
    func imagePreviewURL_withMultipleDots_insertsPreviewBeforeLastExtension() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/files/image.backup.jpg"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://example.com/files/image.backup.preview.jpg",
            "It should replace the last extension with .preview.jpg when multiple dots exist"
        )
    }

    @Test("It should handle single character filenames and use .preview.jpg extension")
    func imagePreviewURL_withSingleCharacterFilename_insertsPreviewCorrectly() throws {
        // Given
        let url = try #require(URL(string: "https://example.com/a.jpg"))

        // When
        let result = url.imagePreviewURL

        // Then
        #expect(
            result.absoluteString == "https://example.com/a.preview.jpg",
            "It should handle single character filenames and use .preview.jpg extension"
        )
    }
}
