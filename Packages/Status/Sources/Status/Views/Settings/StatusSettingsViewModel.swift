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
