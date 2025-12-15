import AuthSessionServiceInterface
import Foundation
import Observation
import PastebinRepository
import SessionServiceInterface

@MainActor
@Observable
final class PastebinAppViewModel {

    // MARK: - Properties

    private(set) var address: Address = .notSet
    private(set) var disableAddButton = true
    private(set) var disableRefreshButton = false
    private(set) var isLoading = false

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private let repository: any PastebinRepositoryProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        repository: any PastebinRepositoryProtocol
    ) {
        self.authSessionService = authSessionService
        self.sessionService = sessionService
        self.repository = repository

        setUpObservers()
    }

    deinit {
        observationTask?.cancel()
    }

    // MARK: - Public

    func fetchPastes() {
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

            try await repository.fetchPastes()
        }
    }

    // MARK: - Private

    private func setUpObservers() {
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
