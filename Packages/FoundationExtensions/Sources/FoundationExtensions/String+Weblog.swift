import Foundation

public extension String {

    /// Creates a weblog entry body with frontmatter from the string content.
    ///
    /// This method formats the string as a weblog entry by adding frontmatter
    /// with the specified publication date and status. The resulting format follows the
    /// OMG.LOL weblog API requirements with ISO 8601 date formatting.
    ///
    /// The output format is:
    /// ```
    /// ---
    /// Date: YYYY-MM-DD HH:MM
    /// Status: [status value]
    /// ---
    ///
    /// [string content]
    /// ```
    ///
    /// - Parameters:
    ///   - date: The publication date to include in the frontmatter
    ///   - status: The publication status to include in the frontmatter (e.g., "Draft", "Live", "Feed Only", "Web
    /// Only", "Unlisted")
    /// - Returns: UTF-8 encoded data containing the formatted weblog entry body
    func weblogEntryBody(
        date: Date,
        status: String
    ) -> Data {
        let formattedString = DateFormatter.iso8601WithShortTime.string(from: date)
        let body = """
        ---
        Date: \(formattedString)
        Status: \(status)
        ---

        \(self)
        """
        return body.data(using: .utf8) ?? Data()
    }
}
