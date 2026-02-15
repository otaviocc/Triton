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
import OMGAPI

/// A response model representing a Permanent URL (PURL) fetched from the network.
///
/// This model serves as the data transfer object between the network layer and client code
/// for PURL operations. It represents a permanent URL entry that redirects from a short,
/// memorable name to a longer target URL, providing stable link management functionality.
///
/// PURLs (Permanent URLs) are short aliases that redirect to longer target URLs, allowing
/// users to create memorable, stable links that can be updated without changing the
/// permanent identifier. They're particularly useful for sharing links that may change
/// over time or for creating branded short URLs.
///
/// The model conforms to `Identifiable` for use in SwiftUI lists and collections,
/// `Equatable` for value comparison, and `Sendable` for safe concurrent usage.
public struct PURLResponse: Identifiable, Equatable, Sendable {

    /// The unique name/identifier of the PURL.
    ///
    /// This serves as both the human-readable identifier and the URL path component
    /// for the permanent URL. It must be unique within the user's address and is
    /// used to construct the final permanent URL (e.g., "example.com/name").
    /// The name should be short, memorable, and URL-safe.
    public let name: String

    /// The target URL that the PURL redirects to.
    ///
    /// This is the original, longer URL that users will be redirected to when
    /// they access the permanent URL. It can be any valid URL, including complex
    /// URLs with parameters, deep links, or frequently changing content URLs.
    public let url: URL

    /// The unique identifier for SwiftUI list operations.
    ///
    /// This computed property uses the PURL name as the unique identifier,
    /// since PURL names are guaranteed to be unique within a user's address.
    /// This enables efficient SwiftUI list rendering and item identification.
    public var id: String {
        name
    }
}
