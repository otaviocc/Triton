import Foundation

public extension DateFormatter {

    /// A DateFormatter configured for weblog entry timestamps.
    ///
    /// This formatter produces ISO 8601 compatible date strings with short time
    /// format, specifically designed for use in weblog entry frontmatter. The
    /// formatter uses the user timezone and POSIX locale for consistent formatting
    /// across different system configurations.
    ///
    /// Output format: `YYYY-MM-DD HH:MM`
    ///
    /// Example: `2024-03-15 14:30`
    static func iso8601WithShortTime(
        timeZone: TimeZone
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        return formatter
    }
}
