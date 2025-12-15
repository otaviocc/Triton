import AuthRepository
import Foundation
import Observation
import OMGAPI

@MainActor
@Observable
final class LoginViewModel {

    // MARK: - Properties

    private let repository: AuthRepositoryProtocol

    // MARK: - Computed Properties

    var codeRequestURL: URL {
        AuthRequestFactory.makeOAuthCodeRequestURL()!
    }

    // MARK: - Lifecycle

    init(
        repository: AuthRepositoryProtocol
    ) {
        self.repository = repository
    }

    // MARK: - Public

    func handleDeeplinkURL(
        _ url: URL
    ) {
        Task { [weak self] in
            guard let self else { return }
            try await repository.handleDeepLinkURL(url)
        }
    }
}
