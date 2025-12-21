import Foundation
import SwiftData

public extension WeblogTag {

    /// Creates a fetch descriptor for retrieving tags sorted alphabetically by title.
    ///
    /// This method provides a pre-configured fetch descriptor that sorts tags
    /// by title in ascending order (A-Z). This is the standard sorting order
    /// for displaying tag collections, presenting them in a predictable alphabetical
    /// sequence for easy browsing and selection.
    ///
    /// - Returns: A `FetchDescriptor<WeblogTag>` configured for alphabetical title sorting.
    static func fetchDescriptor() -> FetchDescriptor<WeblogTag> {
        .init(
            sortBy: [.init(\.title)]
        )
    }
}
