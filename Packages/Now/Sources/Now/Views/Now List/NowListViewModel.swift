import Foundation
import NowPersistenceService
import NowRepository
import Observation
import SessionServiceInterface
import SwiftData

@MainActor
@Observable
final class NowListViewModel {

    // MARK: - Properties

    private let address: SelectedAddress
    private let repository: any NowRepositoryProtocol

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        repository: any NowRepositoryProtocol
    ) {
        self.address = address
        self.repository = repository
    }

    // MARK: - Public

    func fetchNowPage() async throws {
        try await repository.fetchNowPage()
    }

    func fetchDescriptor() -> FetchDescriptor<Now> {
        .make(for: address, limit: 3)
    }
}
