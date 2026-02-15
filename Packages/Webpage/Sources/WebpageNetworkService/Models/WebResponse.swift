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

/// A response model representing webpage content fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code
/// for webpage content operations. It encapsulates both the webpage content and its
/// metadata, transformed from the raw API response into a client-friendly format.
///
/// The model conforms to `Equatable` for value comparison and `Sendable` for safe
/// concurrent usage across different actors and isolation domains.
///
/// This model is primarily used in streaming scenarios where webpage content changes
/// need to be communicated to observers in real-time.
public struct WebResponse: Equatable, Sendable {

    // MARK: - Properties

    /// The markdown content of the webpage.
    ///
    /// This contains the full webpage content in markdown format, ready for
    /// rendering or editing. The content represents the current published
    /// state of the webpage as stored on the remote server.
    public let markdownContent: String

    /// The timestamp when the webpage was last modified.
    ///
    /// This timestamp is provided as a Double representing Unix time and is used
    /// for versioning, conflict resolution, and displaying last-modified information
    /// to users. It reflects the server-side modification time, not when the
    /// content was fetched locally.
    public let timestamp: Double

    // MARK: - Lifecycle

    /// Initializes a new webpage response with content and timestamp.
    ///
    /// This initializer is typically used when converting from network response
    /// models or when creating response objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - markdownContent: The webpage content in markdown format.
    ///   - timestamp: The last modification timestamp as Unix time.
    public init(
        markdownContent: String,
        timestamp: Double
    ) {
        self.markdownContent = markdownContent
        self.timestamp = timestamp
    }
}
