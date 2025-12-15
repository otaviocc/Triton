import AuthSessionServiceInterface
import Foundation
import Observation
import SessionServiceInterface
import WebpageRepository

@MainActor
@Observable
final class WebpageAppViewModel {

    // MARK: - Properties

    private(set) var address: Address = .notSet
    private(set) var disableRefreshButton = false
    private(set) var isLoading = false

    private let authSessionService: any AuthSessionServiceProtocol
    private let sessionService: any SessionServiceProtocol
    private let repository: any WebpageRepositoryProtocol

    @ObservationIgnored private var observationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        repository: any WebpageRepositoryProtocol
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

    func fetchWebpage() {
        Task { [weak self] in
            guard let self else { return }

            await MainActor.run {
                isLoading = true
                disableRefreshButton = true
            }

            defer {
                Task { [weak self] in
                    self?.isLoading = false
                    self?.disableRefreshButton = false
                }
            }

            try await repository.fetchWebpage()
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
