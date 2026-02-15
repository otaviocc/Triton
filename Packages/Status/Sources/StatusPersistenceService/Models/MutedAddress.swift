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

/// A SwiftData model representing a muted address in the local database.
///
/// This model maintains a list of addresses that should be filtered from
/// the status timeline. Users can add addresses to this list to prevent
/// their status updates from appearing in the timeline view.
@Model
public final class MutedAddress {

    // MARK: - Properties

    /// The address of the muted user.
    ///
    /// This serves as the unique identifier for muted addresses in the database,
    /// ensuring that each address can only be muted once.
    public private(set) var address: String

    /// The timestamp when the address was muted.
    ///
    /// This timestamp is used for sorting the mute list chronologically,
    /// with more recently muted addresses appearing first.
    public private(set) var mutedAt: Date

    // MARK: - Unique constraints

    // Ensures only one mute entry per address is stored in the database.
    #Unique<MutedAddress>([\.address])

    // MARK: - Lifecycle

    /// Initializes a new muted address entry.
    ///
    /// - Parameters:
    ///   - address: The address to mute.
    ///   - mutedAt: The timestamp when the address was muted. Defaults to current date.
    public init(
        address: String,
        mutedAt: Date = Date()
    ) {
        self.address = address
        self.mutedAt = mutedAt
    }
}
