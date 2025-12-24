import Foundation

public extension String {

    /// Creates a weblog entry body with frontmatter from the string content.
    ///
    /// This method formats the string as a weblog entry by adding frontmatter
    /// with the specified publication date, status, and tags. The resulting format follows the
    /// OMG.LOL weblog API requirements with ISO 8601 date formatting.
    ///
    /// The output format is:
    /// ```
    /// ---
    /// Date: YYYY-MM-DD HH:MM
    /// Status: [status value]
    /// Tags: Tag1, Tag2, Tag3
    /// ---
    ///
    /// [string content]
    /// ```
    ///
    /// - Parameters:
    ///   - date: The publication date to include in the frontmatter
    ///   - timeZone: The timezone used for the publication (defaults to user's current timezone)
    ///   - status: The publication status to include in the frontmatter (e.g., "Draft", "Live", "Feed Only", "Web
    /// Only", "Unlisted")
    ///   - tags: An array of tags to include in the frontmatter. Tags are comma-separated.
    /// - Returns: UTF-8 encoded data containing the formatted weblog entry body
    func weblogEntryBody(
        date: Date,
        timeZone: TimeZone = .current,
        status: String,
        tags: [String]
    ) -> Data {
        let formattedString = DateFormatter
            .iso8601WithShortTime(timeZone: timeZone)
            .string(from: date)

        var frontmatter = """
        ---
        Date: \(formattedString)
        Status: \(status)
        """

        if !tags.isEmpty {
            let tagsString = tags.joined(separator: ", ")
            frontmatter += "\nTags: \(tagsString)"
        }

        frontmatter += "\n---\n\n\(self)"

        return frontmatter.data(using: .utf8) ?? Data()
    }
}
