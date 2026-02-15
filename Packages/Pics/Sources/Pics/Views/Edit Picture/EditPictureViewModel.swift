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
import FoundationExtensions
import Observation
import PicsRepository

@MainActor
@Observable
final class EditPictureViewModel {

    // MARK: - Nested types

    enum TagSelectionError: Error {

        case noSuggestions
    }

    // MARK: - Properties

    let pictureID: String
    var caption = ""
    var altText = ""
    var tagInput = ""
    var shouldDismiss = false
    private(set) var tags: [String] = []
    private(set) var suggestedTags: [String] = []
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any PicsRepositoryProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    var shouldShowProgress: Bool {
        isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        caption: String = "",
        altText: String = "",
        tags: [String] = [],
        pictureID: String = "",
        repository: any PicsRepositoryProtocol
    ) {
        self.address = address
        self.caption = caption
        self.altText = altText
        self.tags = tags
        self.pictureID = pictureID
        self.repository = repository
    }

    // MARK: - Public

    func updatePicture() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.updatePicture(
                    address: address,
                    pictureID: pictureID,
                    caption: caption,
                    alt: altText,
                    tags: tags
                )
                try await repository.fetchPictures()
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }

    func updateTagSuggestions(
        from existingTags: [String]
    ) {
        let trimmedInput = tagInput
            .slugified()
            .lowercased()

        guard !trimmedInput.isEmpty else {
            suggestedTags = []
            return
        }

        suggestedTags = existingTags
            .filter { tag in
                tag.lowercased().contains(trimmedInput) && !tags.contains(tag)
            }
            .prefix(5)
            .map(\.self)
    }

    func addTag(_ tag: String) {
        let trimmedTag = tag.slugified()

        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else {
            tagInput = ""
            return
        }

        tags.append(trimmedTag)
        tagInput = ""
    }

    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    func selectFirstTagSuggestion() throws(TagSelectionError) {
        guard let tag = suggestedTags.first else {
            throw .noSuggestions
        }

        addTag(tag)
    }
}
