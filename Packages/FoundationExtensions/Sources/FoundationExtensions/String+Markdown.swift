import Foundation

public extension String {

    /// Wraps the string content in a markdown code block.
    ///
    /// This method formats the string by wrapping it in triple backticks (```) to create
    /// a markdown code block, useful for displaying code or preformatted text in markdown.
    ///
    /// - Returns: A string formatted as a markdown code block with the original content.
    ///
    /// ## Example
    /// ```swift
    /// let code = "print(\"Hello, World!\")"
    /// let formatted = code.markdownFormattedCodeBlock()
    /// // Returns:
    /// // ```
    /// // print("Hello, World!")
    /// // ```
    /// ```
    func markdownFormattedCodeBlock() -> String {
        """
        ```
        \(self)
        ```
        """
    }
}
