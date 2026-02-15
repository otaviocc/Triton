// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import SwiftData

public extension FetchDescriptor where T == PURL {

    // MARK: - Nested types

    /// Sort options for PURL lists.
    ///
    /// This enum provides sorting options for organizing PURL collections,
    /// allowing the UI to display PURLs ordered by name or domain in either
    /// ascending or descending order.
    enum SortOption {

        case nameAscending
        case nameDescending
        case domainAscending
        case domainDescending
    }

    // MARK: - Public

    /// Creates the default fetch descriptor sorted alphabetically by name.
    ///
    /// This is the standard descriptor for displaying PURLs in alphabetical
    /// order by name, which provides a consistent and user-friendly display.
    ///
    /// - Returns: A `FetchDescriptor<PURL>` configured for name-ascending sort.
    static func makeDefault() -> FetchDescriptor<PURL> {
        .init(sortBy: [.init(\.name, order: .forward)])
    }

    /// Creates a fetch descriptor for a specific address with custom sorting.
    ///
    /// This method creates a descriptor that filters PURLs by address and applies
    /// the specified sorting order. The address filtering ensures that only PURLs
    /// belonging to the specified user address are returned.
    ///
    /// - Parameters:
    ///   - address: The user address to filter PURLs by.
    ///   - sort: The sort option to apply to the PURL results.
    /// - Returns: A `FetchDescriptor<PURL>` configured with the address filter and sort order.
    static func make(
        for address: String,
        sortedBy sort: SortOption
    ) -> FetchDescriptor<PURL> {
        let sortDescriptors: [SortDescriptor<PURL>] = switch sort {
        case .nameAscending: [.init(\.name, order: .forward)]
        case .nameDescending: [.init(\.name, order: .reverse)]
        case .domainAscending: [.init(\.hostname, order: .forward)]
        case .domainDescending: [.init(\.hostname, order: .reverse)]
        }

        return .init(
            predicate: #Predicate<PURL> { purl in
                purl.address == address
            },
            sortBy: sortDescriptors
        )
    }
}
