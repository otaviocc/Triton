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
import StatusRepository

@MainActor
@Observable
final class StatusSettingsViewModel {

    // MARK: - Properties

    var newAddress = ""
    var newKeyword = ""

    private let repository: any StatusRepositoryProtocol

    // MARK: - Lifecycle

    init(
        repository: any StatusRepositoryProtocol
    ) {
        self.repository = repository
    }

    // MARK: - Public

    func muteAddress() {
        let address = newAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !address.isEmpty else { return }

        Task {
            try? await repository.muteAddress(address: address)
            newAddress = ""
        }
    }

    func unmuteAddress(_ address: String) {
        Task {
            try? await repository.unmuteAddress(address: address)
        }
    }

    func muteKeyword() {
        let keyword = newKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else { return }

        Task {
            try? await repository.muteKeyword(keyword: keyword)
            newKeyword = ""
        }
    }

    func unmuteKeyword(_ keyword: String) {
        Task {
            try? await repository.unmuteKeyword(keyword: keyword)
        }
    }
}
