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
import PastebinPersistenceService
import PastebinRepository
import SessionServiceInterface
import SwiftData

@MainActor
@Observable
final class PastesListViewModel {

    // MARK: - Properties

    private let address: SelectedAddress
    private let repository: any PastebinRepositoryProtocol
    private var sort: PastesListSort

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        sort: PastesListSort,
        repository: any PastebinRepositoryProtocol
    ) {
        self.address = address
        self.sort = sort
        self.repository = repository
    }

    // MARK: - Public

    func fetchPastes() async throws {
        try await repository.fetchPastes()
    }

    func fetchDescriptor() -> FetchDescriptor<Paste> {
        let sortOption = convertToSortOption(sort)
        return .make(for: address, sortedBy: sortOption)
    }

    // MARK: - Private

    private func convertToSortOption(
        _ sort: PastesListSort
    ) -> FetchDescriptor<Paste>.SortOption {
        switch sort {
        case .titleAscending: .titleAscending
        case .titleDescending: .titleDescending
        case .modifiedNewest: .modifiedNewest
        case .modifiedOldest: .modifiedOldest
        }
    }
}
