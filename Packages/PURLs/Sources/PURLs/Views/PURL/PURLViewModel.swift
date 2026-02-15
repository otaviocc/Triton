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
import PURLsPersistenceService
import PURLsRepository

@MainActor
final class PURLViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let title: String
    let originalURL: URL
    let permanentURL: URL
    let address: String

    private let repository: any PURLsRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        title: String,
        originalURL: URL,
        permanentURL: URL,
        address: String,
        repository: any PURLsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.title = title
        self.originalURL = originalURL
        self.permanentURL = permanentURL
        self.address = address
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        purl: PURL,
        repository: any PURLsRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        title = purl.name
        originalURL = purl.url
        permanentURL = URL(purlName: title, for: purl.address)
        address = purl.address

        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPURLToClipboard() {
        clipboardService.copy(
            permanentURL.absoluteString
        )
    }

    func copyMarkdownToClipboard() {
        let markdown = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdown)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePURL(
                address: address,
                name: title
            )
        }
    }
}
