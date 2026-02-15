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
import WeblogRepository

@MainActor
final class WeblogEntryViewModel: Identifiable {

    // MARK: - Properties

    let id: String
    let title: String
    let body: String
    let status: String
    let timestamp: Double
    let address: String
    let location: String
    let tags: [String]

    var publishedDate: Date {
        Date(timeIntervalSince1970: timestamp)
    }

    var formattedDate: String {
        publishedDate
            .formatted(
                date: .abbreviated, time: .omitted
            )
    }

    var permanentURL: URL {
        URL(
            weblogPostFor: address,
            location: location
        )
    }

    var showStatus: Bool {
        status.lowercased() != "live"
    }

    var isDraft: Bool {
        status.lowercased() == "draft"
    }

    private let repository: any WeblogRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        id: String,
        title: String,
        body: String,
        status: String,
        timestamp: Double,
        address: String,
        location: String,
        tags: [String],
        repository: any WeblogRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.status = status
        self.timestamp = timestamp
        self.address = address
        self.location = location
        self.tags = tags
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func copyEntryURLToClipboard() {
        clipboardService.copy(
            permanentURL.absoluteString
        )
    }

    func copyMarkdownLinkToClipboard() {
        let markdownLink = permanentURL.markdownFormatted(
            title: title
        )

        clipboardService.copy(markdownLink)
    }

    func delete() {
        Task { [weak self] in
            guard let self else { return }
            try await repository.deleteEntry(
                address: address,
                entryID: id
            )
        }
    }
}
