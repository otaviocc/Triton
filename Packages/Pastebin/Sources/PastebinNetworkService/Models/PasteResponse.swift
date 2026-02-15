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

/// A response model representing a text paste fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code
/// for pastebin operations. It represents a text snippet stored on the remote server,
/// containing both the content and metadata about the paste.
///
/// Pastebin functionality allows users to store and share text snippets with configurable
/// visibility settings. Each paste has a unique title within the user's address scope
/// and can be either public (listed) or private based on user preferences.
///
/// The model conforms to `Identifiable` for use in SwiftUI lists and collections,
/// `Equatable` for value comparison, and `Sendable` for safe concurrent usage.
public struct PasteResponse: Identifiable, Equatable, Sendable {

    /// The unique title/identifier of the paste.
    ///
    /// This serves as both the human-readable identifier and the unique key
    /// for the paste within the user's address. It must be unique within the
    /// address scope and is used for referencing, updating, and deleting the paste.
    public let title: String

    /// The text content of the paste.
    ///
    /// This contains the actual text content stored in the paste. It can be
    /// any text content including code snippets, notes, configuration files,
    /// or other text-based information that users want to store and share.
    public let content: String

    /// The timestamp when the paste was last modified as a Unix timestamp.
    ///
    /// This represents the server-side modification time and is used for
    /// displaying when the paste was last updated and for chronological
    /// sorting of paste collections.
    public let modifiedOn: Int

    /// The visibility status of the paste.
    ///
    /// This boolean indicates whether the paste is publicly visible (true)
    /// or private (false). Public pastes may be discoverable by others,
    /// while private pastes are only accessible to the owner.
    public let listed: Bool

    /// The unique identifier for SwiftUI list operations.
    ///
    /// This computed property uses the paste title as the unique identifier,
    /// since paste titles are guaranteed to be unique within a user's address.
    /// This enables efficient SwiftUI list rendering and item identification.
    public var id: String {
        title
    }
}
