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
import PastebinPersistenceService
import PastebinRepository

@MainActor
final class PasteViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let title: String
    let content: String
    let address: String
    let listed: Bool

    var permanentURL: URL {
        URL(pasteTitle: title, for: address)
    }

    var isPublic: Bool {
        listed
    }

    private let repository: any PastebinRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        title: String,
        content: String,
        listed: Bool,
        address: String,
        repository: any PastebinRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.title = title
        self.content = content
        self.address = address
        self.listed = listed
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        paste: Paste,
        repository: any PastebinRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        title = paste.title
        content = paste.content
        listed = paste.listed
        address = paste.address

        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyPasteURLToClipboard() {
        clipboardService.copy(permanentURL.absoluteString)
    }

    func copyMarkdownLinkToClipboard() {
        let markdownLink = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdownLink)
    }

    func copyMarkdownCodeBlockToClipboard() {
        clipboardService.copy(content.markdownFormattedCodeBlock())
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deletePaste(
                address: address,
                title: title
            )
        }
    }
}
