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

/// A data transfer object for text pastes intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models for pastebin data. It's designed to be easily convertible
/// from `PasteResponse` objects and into `Paste` SwiftData models.
///
/// The model contains all essential paste data needed for local storage, including
/// the text content, metadata, and visibility settings. It's used by the persistence
/// service to create or update database records that maintain the user's paste
/// collection for offline access and management.
///
/// The model conforms to `Sendable` for safe usage across different concurrency contexts.
public struct StorablePaste: Sendable {

    // MARK: - Properties

    /// The unique title/identifier of the paste.
    ///
    /// This serves as the unique identifier for the paste within the user's
    /// address and must be unique within that scope. It's used for referencing
    /// the paste in database operations and UI components.
    let title: String

    /// The text content of the paste.
    ///
    /// This contains the actual text content that will be stored locally.
    /// The content is preserved exactly as received from the network layer
    /// to maintain consistency between remote and local storage.
    let content: String

    /// The last modification timestamp as a Unix timestamp.
    ///
    /// This represents when the paste was last modified on the server and is
    /// used for sorting and displaying modification dates in the local database.
    /// It's stored as a Double for efficient date calculations.
    let timestamp: Double

    /// The address associated with the paste.
    ///
    /// This identifies which user address the paste belongs to, enabling proper
    /// data organization and multi-address support in local storage. Combined
    /// with the title, it forms a unique identifier for paste storage.
    let address: String

    /// The visibility status of the paste.
    ///
    /// This boolean indicates whether the paste is publicly visible (true)
    /// or private (false). The visibility setting is stored locally to enable
    /// offline viewing of paste configurations and privacy management.
    let listed: Bool

    // MARK: - Lifecycle

    /// Initializes a new storable paste with all required data.
    ///
    /// This initializer is typically used when converting from network response
    /// models during the data synchronization process, or when creating paste
    /// objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - title: The unique title/identifier for the paste.
    ///   - content: The text content of the paste.
    ///   - timestamp: The last modification timestamp as Unix time.
    ///   - address: The user address associated with the paste.
    ///   - listed: Whether the paste is publicly visible (true) or private (false).
    public init(
        title: String,
        content: String,
        timestamp: Double,
        address: String,
        listed: Bool
    ) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.address = address
        self.listed = listed
    }
}
