import Foundation
import SwiftData

public extension MutedKeyword {

    /// Creates a fetch descriptor for retrieving muted keywords sorted by recency.
    ///
    /// This method provides a pre-configured fetch descriptor that sorts muted
    /// keywords by timestamp in descending order (newest first), allowing users
    /// to see their most recently muted keywords at the top of the list.
    ///
    /// - Returns: A `FetchDescriptor<MutedKeyword>` configured for timestamp-descending sort.
    static func fetchDescriptor() -> FetchDescriptor<MutedKeyword> {
        .init(
            sortBy: [.init(\.mutedAt, order: .reverse)]
        )
    }
}
