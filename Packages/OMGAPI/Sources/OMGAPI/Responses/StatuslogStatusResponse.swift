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

public struct StatuslogStatusResponse: Decodable, Identifiable, Sendable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {

        case id
        case address
        case created
        case relativeTime = "relative_time"
        case emoji
        case content
        case externalURL = "external_url"
    }

    // MARK: - Properties

    public let id: String
    public let address: String
    public let created: String
    public let relativeTime: String
    public let emoji: String
    public let content: String
    public let externalURL: URL?

    // MARK: - Lifecycle

    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        id = try container.decode(
            String.self,
            forKey: .id
        )

        address = try container.decode(
            String.self,
            forKey: .address
        )

        created = try container.decode(
            String.self,
            forKey: .created
        )

        relativeTime = try container.decode(
            String.self,
            forKey: .relativeTime
        )

        emoji = try container.decode(
            String.self,
            forKey: .emoji
        )

        content = try container.decode(
            String.self,
            forKey: .content
        )

        externalURL = try container
            .decodeIfPresent(
                String.self,
                forKey: .externalURL
            )
            .flatMap(URL.init(string:))
    }
}
