import Foundation

public extension String {

    /// Creates a weblog entry body with frontmatter from the string content.
    ///
    /// This method formats the string as a weblog entry by adding frontmatter
    /// with the specified publication date. The resulting format follows the
    /// OMG.LOL weblog API requirements with ISO 8601 date formatting.
    ///
    /// The output format is:
    /// ```
    /// ---
    /// Date: YYYY-MM-DD HH:MM
    /// ---
    ///
    /// [string content]
    /// ```
    ///
    /// - Parameter date: The publication date to include in the frontmatter
    /// - Returns: UTF-8 encoded data containing the formatted weblog entry body
    func weblogEntryBody(with date: Date) -> Data {
        let formattedString = DateFormatter.iso8601WithShortTime.string(from: date)
        let body = """
        ---
        Date: \(formattedString)
        ---

        \(self)
        """
        return body.data(using: .utf8) ?? Data()
    }
}
