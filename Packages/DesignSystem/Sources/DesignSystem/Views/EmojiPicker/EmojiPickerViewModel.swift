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
import Observation

@MainActor
@Observable
final class EmojiPickerViewModel {

    // MARK: - Nested types

    private enum EmojiPickerError: Error {

        case missingFile
        case missingData
    }

    // MARK: - Properties

    var searchTerm = ""
    private(set) var emojis: [Emoji] = []

    // MARK: - Computed Properties

    var isSearching: Bool {
        !searchTerm.isEmpty
    }

    var filteredEmojis: [Emoji] {
        guard !searchTerm.isEmpty else { return [] }
        return emojis.filter { $0.keywords.containsPartial(searchTerm) }
    }

    // MARK: - Lifecycle

    init() {
        Task {
            try await loadEmojis()
        }
    }

    // MARK: - Private

    private func loadEmojis() async throws {
        let url = try await emojiURL()
        let emojiData = try await emojiData(url)
        let emojis = try decodeEmoji(from: emojiData)

        self.emojis = emojis
    }

    private func emojiURL() async throws(EmojiPickerError) -> URL {
        let url = Bundle
            .designSystem
            .url(
                forResource: "Emojis",
                withExtension: "json"
            )

        guard let url else {
            throw .missingFile
        }

        return url
    }

    private func emojiData(
        _ url: URL
    ) async throws(EmojiPickerError) -> Data {
        let data = FileManager
            .default
            .contents(
                atPath: url.path
            )

        guard let data else {
            throw .missingData
        }

        return data
    }

    private func decodeEmoji(
        from data: Data
    ) throws -> [Emoji] {
        try JSONDecoder().decode(
            [Emoji].self,
            from: data
        )
    }
}
