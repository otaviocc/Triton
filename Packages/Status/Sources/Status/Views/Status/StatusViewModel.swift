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
import StatusPersistenceService
import StatusRepository

@MainActor
final class StatusViewModel: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let address: String
    let message: String
    let icon: String
    let statusURL: URL
    let timestamp: Double
    let replyURL: URL?

    var backgroundColorID: Int {
        Int(timestamp)
    }

    var relativeDate: String {
        Date(timeIntervalSince1970: timestamp)
            .formatted(
                .relative(presentation: .numeric)
            )
    }

    private let repository: StatusRepositoryProtocol
    private let clipboardService: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        status: Status,
        repository: StatusRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        address = status.username
        message = status.content
        timestamp = status.timestamp
        icon = status.icon
        statusURL = URL(statusID: status.statusID, for: status.username)
        replyURL = status.externalURL
        self.repository = repository
        self.clipboardService = clipboardService
    }

    init(
        address: String,
        message: String,
        icon: String,
        statusURL: URL,
        timestamp: Double,
        replyURL: URL?,
        repository: StatusRepositoryProtocol,
        clipboardService: ClipboardServiceProtocol
    ) {
        self.address = address
        self.message = message
        self.icon = icon
        self.statusURL = statusURL
        self.timestamp = timestamp
        self.replyURL = replyURL
        self.repository = repository
        self.clipboardService = clipboardService
    }

    // MARK: - Public

    func muteAddress() {
        let address = address.trimmingCharacters(in: .whitespacesAndNewlines)

        Task {
            try? await repository.muteAddress(address: address)
        }
    }

    func copyStatusURLToClipboard() {
        clipboardService.copy(
            statusURL.absoluteString
        )
    }

    func copyReplyURLToClipboard() {
        guard let replyURL else { return }

        clipboardService.copy(
            replyURL.absoluteString
        )
    }
}
