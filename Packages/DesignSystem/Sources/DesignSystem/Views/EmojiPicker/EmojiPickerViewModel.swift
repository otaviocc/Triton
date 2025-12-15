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
