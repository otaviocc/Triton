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
