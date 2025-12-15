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
