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
