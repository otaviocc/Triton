import Foundation
import SwiftData

public extension MutedAddress {

    /// Creates a fetch descriptor for retrieving muted addresses sorted by recency.
    ///
    /// This method provides a pre-configured fetch descriptor that sorts muted
    /// addresses by timestamp in descending order (newest first), allowing users
    /// to see their most recently muted addresses at the top of the list.
    ///
    /// - Returns: A `FetchDescriptor<MutedAddress>` configured for timestamp-descending sort.
    static func fetchDescriptor() -> FetchDescriptor<MutedAddress> {
        .init(
            sortBy: [.init(\.mutedAt, order: .reverse)]
        )
    }
}
