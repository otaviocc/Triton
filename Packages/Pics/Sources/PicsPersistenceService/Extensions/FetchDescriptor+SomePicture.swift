import Foundation
import SwiftData

public extension FetchDescriptor where T == SomePicture {

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by creation date (newest first).
    ///
    /// This is the standard descriptor for displaying pictures in reverse
    /// chronological order, showing the most recently uploaded pictures first.
    ///
    /// - Returns: A `FetchDescriptor<SomePicture>` configured for created-descending sort.
    static func makeDefault() -> FetchDescriptor<SomePicture> {
        .init(sortBy: [.init(\.created, order: .reverse)])
    }

    /// Creates a fetch descriptor for a specific address.
    ///
    /// This method creates a descriptor that filters pictures by address, ensuring
    /// that only pictures belonging to the specified user address are returned.
    /// Results are sorted by creation date in descending order (newest first).
    ///
    /// - Parameter address: The user address to filter pictures by.
    /// - Returns: A `FetchDescriptor<SomePicture>` configured with the address filter.
    static func make(for address: String) -> FetchDescriptor<SomePicture> {
        .init(
            predicate: #Predicate<SomePicture> { picture in
                picture.address == address
            },
            sortBy: [
                .init(\.created, order: .reverse)
            ]
        )
    }
}
