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

public extension URL {

    /// Formats the URL as a markdown link or image with optional title.
    ///
    /// This method creates a markdown-formatted link or image string using the URL.
    /// If a title is provided, it's used as the link/alt text; otherwise, the
    /// absolute URL string is used as both the text and the link target.
    /// When `isImage` is true, the result is formatted as a markdown image.
    ///
    /// - Parameters:
    ///   - title: Optional title text for the markdown link or alt text for images.
    ///           If nil, the URL's absolute string is used as the title.
    ///   - isImage: Whether to format as a markdown image (with `!` prefix).
    ///             Defaults to false for standard links.
    /// - Returns: A markdown-formatted string in the format `[title](url)` for links
    ///           or `![title](url)` for images
    /// - Example:
    ///   - `URL(string: "https://example.com")!.markdownFormatted(title: "Example")` → `[Example](https://example.com)`
    ///   - `URL(string: "https://example.com/image.jpg")!.markdownFormatted(title: "My Image", isImage: true)` → `![My
    /// Image](https://example.com/image.jpg)`
    ///   - `URL(string: "https://example.com")!.markdownFormatted()` → `[https://example.com](https://example.com)`
    func markdownFormatted(
        title: String? = nil,
        isImage: Bool = false
    ) -> String {
        "\(isImage ? "!" : "")[\(title ?? absoluteString)](\(absoluteString))"
    }
}
