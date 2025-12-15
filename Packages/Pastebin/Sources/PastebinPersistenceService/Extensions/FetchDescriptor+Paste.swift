import Foundation
import SwiftData

public extension FetchDescriptor where T == Paste {

    // MARK: - Nested types

    /// Sort options for paste lists.
    ///
    /// This enum provides sorting options for organizing paste collections,
    /// allowing the UI to display pastes ordered by title or modification date
    /// in either ascending or descending order.
    enum SortOption {

        case titleAscending
        case titleDescending
        case modifiedNewest
        case modifiedOldest
    }

    // MARK: - Public

    /// Creates the default fetch descriptor sorted alphabetically by title.
    ///
    /// This is the standard descriptor for displaying pastes in alphabetical
    /// order by title, which provides a consistent and user-friendly display.
    ///
    /// - Returns: A `FetchDescriptor<Paste>` configured for title-ascending sort.
    static func makeDefault() -> FetchDescriptor<Paste> {
        .init(sortBy: [.init(\.title, order: .forward)])
    }

    /// Creates a fetch descriptor for a specific address with custom sorting.
    ///
    /// This method creates a descriptor that filters pastes by address and applies
    /// the specified sorting order. The address filtering ensures that only pastes
    /// belonging to the specified user address are returned.
    ///
    /// For modification date sorting, a secondary sort by title is applied to ensure
    /// consistent ordering when multiple pastes have the same modification timestamp.
    ///
    /// - Parameters:
    ///   - address: The user address to filter pastes by.
    ///   - sort: The sort option to apply to the paste results.
    /// - Returns: A `FetchDescriptor<Paste>` configured with the address filter and sort order.
    static func make(
        for address: String,
        sortedBy sort: SortOption
    ) -> FetchDescriptor<Paste> {
        let sortDescriptors: [SortDescriptor<Paste>] = switch sort {
        case .titleAscending: [.init(\.title, order: .forward)]
        case .titleDescending: [.init(\.title, order: .reverse)]
        case .modifiedNewest: [.init(\.timestamp, order: .reverse), .init(\.title, order: .forward)]
        case .modifiedOldest: [.init(\.timestamp, order: .forward), .init(\.title, order: .forward)]
        }

        return .init(
            predicate: #Predicate<Paste> { paste in
                paste.address == address
            },
            sortBy: sortDescriptors
        )
    }
}
