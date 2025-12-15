import AccountUpdateRepository
import AuthSessionServiceInterface
import MicroClient
import SessionServiceInterface

/// Factory responsible for creating account update services and dependencies.
///
/// `AccountUpdateAppFactory` manages the account update functionality including
/// fetching and syncing current account information. It initializes the account update
/// environment with required dependencies and provides methods to create account update services.
///
/// ## Usage
///
/// ```swift
/// let factory = AccountUpdateAppFactory(
///     sessionService: sessionService,
///     authSessionService: authSession,
///     networkClient: client
/// )
///
/// let updateService = factory.makeAccountUpdateService()
/// ```
public final class AccountUpdateAppFactory {

    // MARK: - Properties

    private let environment: AccountUpdateEnvironment

    // MARK: - Lifecycle

    public init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        environment = .init(
            sessionService: sessionService,
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    // MARK: - Public

    /// Creates an account update service.
    ///
    /// This method constructs an account update service with all necessary dependencies
    /// injected. The service handles fetching current account information from the API
    /// and updating the session with the latest account data.
    ///
    /// - Returns: A configured account update service ready for use.
    public func makeAccountUpdateService() -> AccountUpdateService {
        .init(
            updateRepository: environment.accountUpdateRepository
        )
    }
}
