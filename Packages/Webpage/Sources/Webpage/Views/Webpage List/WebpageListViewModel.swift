import Foundation
import Observation
import SessionServiceInterface
import SwiftData
import WebpagePersistenceService
import WebpageRepository

@MainActor
@Observable
final class WebpageListViewModel {

    // MARK: - Properties

    private let address: SelectedAddress
    private let repository: any WebpageRepositoryProtocol

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        repository: any WebpageRepositoryProtocol
    ) {
        self.address = address
        self.repository = repository
    }

    // MARK: - Public

    func fetchWebpages() async throws {
        try await repository.fetchWebpage()
    }

    func fetchDescriptor() -> FetchDescriptor<Webpage> {
        .make(for: address, limit: 3)
    }
}
