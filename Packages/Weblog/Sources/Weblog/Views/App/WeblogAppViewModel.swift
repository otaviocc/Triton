import AuthSessionServiceInterface
import Foundation
import Observation
import SessionServiceInterface
import WeblogRepository

@MainActor
@Observable
final class WeblogAppViewModel {

    // MARK: - Properties

    private(set) var address: Address = .notSet
    private(set) var disableAddButton = true
    private(set) var disableRefreshButton = false
    private(set) var isLoading = false

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private let repository: any WeblogRepositoryProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        repository: any WeblogRepositoryProtocol
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

    func fetchEntries() {
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

            try await repository.fetchEntries()
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
