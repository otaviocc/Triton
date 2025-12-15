import Foundation
import Observation
import PURLsPersistenceService
import PURLsRepository
import SessionServiceInterface
import SwiftData

@MainActor
@Observable
final class PURLsListViewModel {

    // MARK: - Properties

    private let address: SelectedAddress
    private let repository: any PURLsRepositoryProtocol
    private var sort: PURLsListSort

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        sort: PURLsListSort,
        repository: any PURLsRepositoryProtocol
    ) {
        self.address = address
        self.sort = sort
        self.repository = repository
    }

    // MARK: - Public

    func fetchPURLs() async throws {
        try await repository.fetchPURLs()
    }

    func fetchDescriptor() -> FetchDescriptor<PURL> {
        let sortOption = convertToSortOption(sort)
        return .make(for: address, sortedBy: sortOption)
    }

    // MARK: - Private

    private func convertToSortOption(
        _ sort: PURLsListSort
    ) -> FetchDescriptor<PURL>.SortOption {
        switch sort {
        case .nameAscending: .nameAscending
        case .nameDescending: .nameDescending
        case .domainAscending: .domainAscending
        case .domainDescending: .domainDescending
        }
    }
}
