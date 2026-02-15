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

public struct WeblogEntryResponse: Decodable, Identifiable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case id = "entry"
        case address
        case location
        case title
        case date
        case type
        case status
        case source
        case body
        case output
        case metadata
    }

    // MARK: - Properties

    public let id: String
    public let address: String
    public let location: String
    public let title: String
    public let date: Double
    public let type: String
    public let status: String
    public let source: String
    public let body: String
    public let output: String
    public let metadata: String

    /// Extracts tags from the metadata JSON string.
    ///
    /// The metadata field contains a JSON string with entry metadata which might include tags.
    /// Tags are stored as a dictionary where keys are lowercase slugs and values
    /// preserve the original case (e.g., `{"tags":{"foo":"Foo","bar":"Bar"}}`).
    ///
    /// - Returns: An array of tag strings, preserving original case. Returns empty array if parsing fails or no tags
    /// exist.
    public var tags: [String] {
        guard let data = metadata.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let tagsDict = json["tags"] as? [String: String]
        else {
            return []
        }

        return .init(tagsDict.values).sorted()
    }
}
