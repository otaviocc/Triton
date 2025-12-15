import Foundation
import SwiftData

public extension FetchDescriptor where T == Now {

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by timestamp (newest first).
    ///
    /// This is the standard descriptor for displaying Now page updates in
    /// reverse chronological order, showing the most recent updates first.
    ///
    /// - Returns: A `FetchDescriptor<Now>` configured for timestamp-descending sort.
    static func makeDefault() -> FetchDescriptor<Now> {
        .init(sortBy: [.init(\.timestamp, order: .reverse)])
    }

    /// Creates a fetch descriptor for a specific address with a limit on results.
    ///
    /// This method creates a descriptor that filters Now page updates by address
    /// and limits the number of results returned. The address filtering ensures
    /// that only updates belonging to the specified user address are returned.
    /// Results are sorted by timestamp in descending order (newest first).
    ///
    /// The fetch limit is useful for displaying a preview of recent Now page
    /// updates without loading the entire history.
    ///
    /// - Parameters:
    ///   - address: The user address to filter Now page updates by.
    ///   - limit: The maximum number of results to return (defaults to 3).
    /// - Returns: A `FetchDescriptor<Now>` configured with the address filter and fetch limit.
    static func make(
        for address: String,
        limit: Int = 3
    ) -> FetchDescriptor<Now> {
        var descriptor = FetchDescriptor<Now>(
            predicate: #Predicate<Now> { now in
                now.address == address
            },
            sortBy: [
                .init(\.timestamp, order: .reverse)
            ]
        )

        descriptor.fetchLimit = limit

        return descriptor
    }
}
