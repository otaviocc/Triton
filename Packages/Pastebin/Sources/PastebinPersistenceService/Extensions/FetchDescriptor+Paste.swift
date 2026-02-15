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
