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

/// A data transfer object for Permanent URLs (PURLs) intended for persistence operations.
///
/// This model serves as an intermediate representation between network responses
/// and SwiftData models for PURL data. It's designed to be easily convertible
/// from `PURLResponse` objects and into `PURL` SwiftData models.
///
/// The model contains all essential PURL data needed for local storage, including
/// the permanent identifier (name), target URL, and associated user address.
/// It's used by the persistence service to create or update database records that
/// maintain the user's PURL collection for offline access and management.
public struct StorablePURL {

    // MARK: - Properties

    /// The unique name/identifier of the PURL.
    ///
    /// This serves as the permanent identifier for the redirect and must be
    /// unique within the user's address. It's used to construct the permanent
    /// URL path and will be persisted for offline access to PURL management.
    let name: String

    /// The target URL that the PURL redirects to.
    ///
    /// This is the destination URL where users will be redirected when accessing
    /// the permanent URL. It's stored locally to enable offline viewing of
    /// PURL configurations and target management.
    let url: URL

    /// The address associated with the PURL.
    ///
    /// This identifies which user address the PURL belongs to, enabling proper
    /// data organization and multi-address support in local storage. Combined
    /// with the name, it forms a unique identifier for PURL storage.
    let address: String

    // MARK: - Lifecycle

    /// Initializes a new storable PURL with all required data.
    ///
    /// This initializer is typically used when converting from network response
    /// models during the data synchronization process, or when creating PURL
    /// objects programmatically for testing purposes.
    ///
    /// - Parameters:
    ///   - name: The unique name/identifier for the PURL.
    ///   - url: The target URL that the PURL redirects to.
    ///   - address: The user address associated with the PURL.
    public init(
        name: String,
        url: URL,
        address: String
    ) {
        self.name = name
        self.url = url
        self.address = address
    }
}
