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

/// A SwiftData model representing a muted keyword in the local database.
///
/// This model maintains a list of keywords that should be used to filter
/// status updates from the timeline. Status updates containing any of these
/// keywords in their content will be hidden from the timeline view.
@Model
public final class MutedKeyword {

    // MARK: - Properties

    /// The keyword or phrase to mute.
    ///
    /// This serves as the unique identifier for muted keywords in the database,
    /// ensuring that each keyword can only be muted once. Matching is case-insensitive.
    public private(set) var keyword: String

    /// The timestamp when the keyword was muted.
    ///
    /// This timestamp is used for sorting the mute list chronologically,
    /// with more recently muted keywords appearing first.
    public private(set) var mutedAt: Date

    // MARK: - Unique constraints

    // Ensures only one mute entry per keyword is stored in the database.
    #Unique<MutedKeyword>([\.keyword])

    // MARK: - Lifecycle

    /// Initializes a new muted keyword entry.
    ///
    /// - Parameters:
    ///   - keyword: The keyword or phrase to mute.
    ///   - mutedAt: The timestamp when the keyword was muted. Defaults to current date.
    public init(
        keyword: String,
        mutedAt: Date = Date()
    ) {
        self.keyword = keyword
        self.mutedAt = mutedAt
    }
}
