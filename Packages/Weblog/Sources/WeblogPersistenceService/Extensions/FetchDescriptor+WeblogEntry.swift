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

public extension FetchDescriptor where T == WeblogEntry {

    // MARK: - Nested types

    /// Sort options for weblog entry lists.
    ///
    /// This enum provides sorting options for organizing weblog entry collections,
    /// allowing the UI to display entries ordered by title or published date
    /// in either ascending or descending order.
    enum SortOption {

        case titleAscending
        case titleDescending
        case publishedDateAscending
        case publishedDateDescending
    }

    // MARK: - Public

    /// Creates the default fetch descriptor sorted by published date (newest first).
    ///
    /// This is the standard descriptor for displaying weblog entries in reverse
    /// chronological order, showing the most recently published entries first.
    ///
    /// - Returns: A `FetchDescriptor<WeblogEntry>` configured for date-descending sort.
    static func makeDefault() -> FetchDescriptor<WeblogEntry> {
        .init(sortBy: [.init(\.date, order: .reverse)])
    }

    /// Creates a fetch descriptor for a specific address with custom sorting.
    ///
    /// This method creates a descriptor that filters weblog entries by address and
    /// applies the specified sorting order. The address filtering ensures that only
    /// entries belonging to the specified user address are returned.
    ///
    /// For all sorting options, a secondary sort by title is applied to ensure
    /// consistent ordering when multiple entries have the same published date.
    ///
    /// - Parameters:
    ///   - address: The user address to filter weblog entries by.
    ///   - sort: The sort option to apply to the weblog entry results.
    /// - Returns: A `FetchDescriptor<WeblogEntry>` configured with the address filter and sort order.
    static func make(
        for address: String,
        sortedBy sort: SortOption
    ) -> FetchDescriptor<WeblogEntry> {
        let sortDescriptors: [SortDescriptor<WeblogEntry>] = switch sort {
        case .titleAscending: [.init(\.title, order: .forward)]
        case .titleDescending: [.init(\.title, order: .reverse)]
        case .publishedDateAscending: [.init(\.date, order: .forward), .init(\.title, order: .forward)]
        case .publishedDateDescending: [.init(\.date, order: .reverse), .init(\.title, order: .forward)]
        }

        return .init(
            predicate: #Predicate<WeblogEntry> { entry in
                entry.address == address
            },
            sortBy: sortDescriptors
        )
    }
}
