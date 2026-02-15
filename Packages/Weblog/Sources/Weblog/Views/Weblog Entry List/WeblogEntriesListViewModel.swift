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
import SessionServiceInterface
import SwiftData
import WeblogPersistenceService
import WeblogRepository

@MainActor
@Observable
final class WeblogEntriesListViewModel {

    // MARK: - Properties

    private let address: SelectedAddress
    private let repository: any WeblogRepositoryProtocol
    private let sort: WeblogEntriesListSort

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        sort: WeblogEntriesListSort,
        repository: any WeblogRepositoryProtocol
    ) {
        self.address = address
        self.sort = sort
        self.repository = repository
    }

    // MARK: - Public

    func fetchWeblogEntries() async throws {
        try await repository.fetchEntries()
    }

    func fetchDescriptor() -> FetchDescriptor<WeblogEntry> {
        let sortOption = convertToSortOption(sort)
        return .make(for: address, sortedBy: sortOption)
    }

    // MARK: - Private

    private func convertToSortOption(
        _ sort: WeblogEntriesListSort
    ) -> FetchDescriptor<WeblogEntry>.SortOption {
        switch sort {
        case .titleAscending: .titleAscending
        case .titleDescending: .titleDescending
        case .publishedDateAscending: .publishedDateAscending
        case .publishedDateDescending: .publishedDateDescending
        }
    }
}
