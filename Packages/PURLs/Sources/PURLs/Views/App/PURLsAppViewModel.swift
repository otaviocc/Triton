import AuthSessionServiceInterface
import Foundation
import Observation
import PURLsRepository
import SessionServiceInterface

@MainActor
@Observable
final class PURLsAppViewModel {

    // MARK: - Properties

    private(set) var address: Address = .notSet
    private(set) var disableAddButton = true
    private(set) var disableRefreshButton = false
    private(set) var isLoading = false

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private let repository: any PURLsRepositoryProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        repository: any PURLsRepositoryProtocol
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

    func fetchPURLs() {
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

            try await repository.fetchPURLs()
        }
    }

    // MARK: - Private

    private func observeAddressChanges() {
        observationTask = Task { [weak self] in
            guard let self else { return }

            for await address in sessionService.observeAddress() {
                await MainActor.run {
                    self.address = address
                    self.disableAddButton = address == .notSet
                }
            }
        }
    }
}
