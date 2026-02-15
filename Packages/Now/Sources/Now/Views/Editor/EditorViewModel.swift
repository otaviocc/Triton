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
import NowRepository
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class EditorViewModel {

    // MARK: - Properties

    let viewTitle = "Now Page"
    var content: String
    var isListed = false
    var shouldDismiss = false
    private(set) var isSubmitting = false

    private let address: String
    private let repository: any NowRepositoryProtocol
    private let sessionService: any SessionServiceProtocol

    // MARK: - Computed Properties

    var isSubmitDisabled: Bool {
        content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting
    }

    // MARK: - Lifecycle

    init(
        address: String,
        content: String = "",
        isListed: Bool,
        repository: any NowRepositoryProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.address = address
        self.content = content
        self.isListed = isListed
        self.repository = repository
        self.sessionService = sessionService
    }

    // MARK: - Public

    func publishNowPage() {
        isSubmitting = true

        Task {
            defer { isSubmitting = false }

            do {
                try await repository.updateNowPage(
                    address: address,
                    content: content,
                    isListed: isListed
                )
                shouldDismiss = true
            } catch {
                // Error handled by defer
            }
        }
    }
}
