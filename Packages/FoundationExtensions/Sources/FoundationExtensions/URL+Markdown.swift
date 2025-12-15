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
