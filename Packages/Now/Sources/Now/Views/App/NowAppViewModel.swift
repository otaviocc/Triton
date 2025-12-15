import AuthSessionServiceInterface
import Foundation
import NowRepository
import Observation
import SessionServiceInterface

@MainActor
@Observable
final class NowAppViewModel {

    // MARK: - Properties

    private(set) var address: Address = .notSet
    private(set) var disableRefreshButton = false
    private(set) var isLoading = false

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private let repository: any NowRepositoryProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        repository: any NowRepositoryProtocol
    ) {
        self.authSessionService = authSessionService
        self.sessionService = sessionService
        self.repository = repository

        observeAddressChanges()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func fetchNow() {
        Task { [weak self] in
            guard let self else { return }

            isLoading = true
            disableRefreshButton = true

            defer {
                Task { [weak self] in
                    self?.isLoading = false
                    self?.disableRefreshButton = false
                }
            }

            try await repository.fetchNowPage()
        }
    }

    // MARK: - Private

    private func observeAddressChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await address in sessionService.observeAddress() {
                await MainActor.run {
                    self.address = address
                }
            }
        }
    }
}
