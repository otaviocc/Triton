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
