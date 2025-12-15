import Foundation
import SwiftData

public extension FetchDescriptor where T == Webpage {

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by timestamp (newest first).
    ///
    /// This is the standard descriptor for displaying webpage updates in
    /// reverse chronological order, showing the most recent updates first.
    ///
    /// - Returns: A `FetchDescriptor<Webpage>` configured for timestamp-descending sort.
    static func makeDefault() -> FetchDescriptor<Webpage> {
        .init(sortBy: [.init(\.timestamp, order: .reverse)])
    }

    /// Creates a fetch descriptor for a specific address with a limit on results.
    ///
    /// This method creates a descriptor that filters webpage updates by address
    /// and limits the number of results returned. The address filtering ensures
    /// that only updates belonging to the specified user address are returned.
    /// Results are sorted by timestamp in descending order (newest first).
    ///
    /// The fetch limit is useful for displaying a preview of recent webpage
    /// updates without loading the entire history.
    ///
    /// - Parameters:
    ///   - address: The user address to filter webpage updates by.
    ///   - limit: The maximum number of results to return (defaults to 3).
    /// - Returns: A `FetchDescriptor<Webpage>` configured with the address filter and fetch limit.
    static func make(
        for address: String,
        limit: Int = 3
    ) -> FetchDescriptor<Webpage> {
        var descriptor = FetchDescriptor<Webpage>(
            predicate: #Predicate<Webpage> { webpage in
                webpage.address == address
            },
            sortBy: [
                .init(\.timestamp, order: .reverse)
            ]
        )

        descriptor.fetchLimit = limit

        return descriptor
    }
}
