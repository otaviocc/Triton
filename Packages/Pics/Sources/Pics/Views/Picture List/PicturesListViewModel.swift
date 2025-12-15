import Foundation
import Observation
import PicsPersistenceService
import PicsRepository
import SessionServiceInterface
import SwiftData

@MainActor
@Observable
final class PicturesListViewModel {

    // MARK: - Properties

    let address: SelectedAddress
    private let repository: any PicsRepositoryProtocol

    // MARK: - Lifecycle

    init(
        address: SelectedAddress,
        repository: any PicsRepositoryProtocol
    ) {
        self.address = address
        self.repository = repository
    }

    // MARK: - Public

    func fetchPictures() async throws {
        try await repository.fetchPictures()
    }

    func fetchDescriptor() -> FetchDescriptor<SomePicture> {
        .make(for: address)
    }
}
