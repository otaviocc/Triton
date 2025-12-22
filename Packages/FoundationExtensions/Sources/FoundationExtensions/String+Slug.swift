import Foundation

public extension String {

    /// Converts a string into a slug-friendly format suitable for URLs or identifiers.
    ///
    /// This method transforms the string by:
    /// - Trimming leading and trailing whitespace
    /// - Replacing whitespace sequences with hyphens
    /// - Removing empty components
    ///
    /// - Returns: A slug-formatted string with words separated by hyphens.
    ///
    /// # Example
    /// ```swift
    /// "Hello World".slugified() // "Hello-World"
    /// "  multiple   spaces  ".slugified() // "multiple-spaces"
    /// "already-slugged".slugified() // "already-slugged"
    /// ```
    func slugified() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}
