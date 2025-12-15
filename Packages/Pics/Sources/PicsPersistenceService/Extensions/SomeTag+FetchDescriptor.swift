import Foundation
import SwiftData

public extension SomeTag {

    /// Creates a fetch descriptor for retrieving tags sorted alphabetically by title.
    ///
    /// This method provides a pre-configured fetch descriptor that sorts tags
    /// by title in ascending order (A-Z). This is the standard sorting order
    /// for displaying tag collections, presenting them in a predictable alphabetical
    /// sequence for easy browsing and selection.
    ///
    /// - Returns: A `FetchDescriptor<SomeTag>` configured for alphabetical title sorting.
    static func fetchDescriptor() -> FetchDescriptor<SomeTag> {
        .init(
            sortBy: [.init(\.title)]
        )
    }
}
