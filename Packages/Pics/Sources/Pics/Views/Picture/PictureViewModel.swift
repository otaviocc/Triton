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

import ClipboardService
import Foundation
import FoundationExtensions
import PicsRepository

@MainActor
final class PictureViewModel: Identifiable {

    // MARK: - Properties

    let id: String
    let title: String?
    let altText: String?
    let photoURL: URL?
    let somePicsURL: URL?
    let timestamp: Double
    let address: String
    let tags: [String]

    var markdownLink: String? {
        somePicsURL?.markdownFormatted(title: title)
    }

    var markdownImage: String? {
        photoURL?.markdownFormatted(title: altText, isImage: true)
    }

    private let repository: any PicsRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        id: String,
        timestamp: Double,
        title: String? = nil,
        altText: String? = nil,
        photoURL: URL? = nil,
        somePicsURL: URL? = nil,
        address: String,
        tags: [String] = [],
        repository: any PicsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.id = id
        self.timestamp = timestamp
        self.title = title
        self.altText = altText
        self.photoURL = photoURL
        self.somePicsURL = somePicsURL
        self.address = address
        self.tags = tags
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPhotoURLToClipboard() {
        guard let photoURL else { return }

        clipboardService.copy(
            photoURL.absoluteString
        )
    }

    func copySomePicsURLToClipboard() {
        guard let somePicsURL else { return }

        clipboardService.copy(
            somePicsURL.absoluteString
        )
    }

    func copyMarkdownLinkToClipboard() {
        guard let markdownLink else { return }

        clipboardService.copy(markdownLink)
    }

    func copyMarkdownImageToClipboard() {
        guard let markdownImage else { return }

        clipboardService.copy(markdownImage)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePicture(
                address: address,
                pictureID: id
            )
        }
    }
}
