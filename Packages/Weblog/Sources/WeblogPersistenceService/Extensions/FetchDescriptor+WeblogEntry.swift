import Foundation
import SwiftData

public extension FetchDescriptor where T == WeblogEntry {

    // MARK: - Nested types

    /// Sort options for weblog entry lists.
    ///
    /// This enum provides sorting options for organizing weblog entry collections,
    /// allowing the UI to display entries ordered by title or published date
    /// in either ascending or descending order.
    enum SortOption {

        case titleAscending
        case titleDescending
        case publishedDateAscending
        case publishedDateDescending
    }

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by published date (newest first).
    ///
    /// This is the standard descriptor for displaying weblog entries in reverse
    /// chronological order, showing the most recently published entries first.
    ///
    /// - Returns: A `FetchDescriptor<WeblogEntry>` configured for date-descending sort.
    static func makeDefault() -> FetchDescriptor<WeblogEntry> {
        .init(sortBy: [.init(\.date, order: .reverse)])
    }

    /// Creates a fetch descriptor for a specific address with custom sorting.
    ///
    /// This method creates a descriptor that filters weblog entries by address and
    /// applies the specified sorting order. The address filtering ensures that only
    /// entries belonging to the specified user address are returned.
    ///
    /// For all sorting options, a secondary sort by title is applied to ensure
    /// consistent ordering when multiple entries have the same published date.
    ///
    /// - Parameters:
    ///   - address: The user address to filter weblog entries by.
    ///   - sort: The sort option to apply to the weblog entry results.
    /// - Returns: A `FetchDescriptor<WeblogEntry>` configured with the address filter and sort order.
    static func make(
        for address: String,
        sortedBy sort: SortOption
    ) -> FetchDescriptor<WeblogEntry> {
        let sortDescriptors: [SortDescriptor<WeblogEntry>] = switch sort {
        case .titleAscending: [.init(\.title, order: .forward)]
        case .titleDescending: [.init(\.title, order: .reverse)]
        case .publishedDateAscending: [.init(\.date, order: .forward), .init(\.title, order: .forward)]
        case .publishedDateDescending: [.init(\.date, order: .reverse), .init(\.title, order: .forward)]
        }

        return .init(
            predicate: #Predicate<WeblogEntry> { entry in
                entry.address == address
            },
            sortBy: sortDescriptors
        )
    }
}
