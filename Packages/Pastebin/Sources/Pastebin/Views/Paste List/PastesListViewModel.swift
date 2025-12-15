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
