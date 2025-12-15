import AccountUpdateNetworkService
import AccountUpdatePersistenceService
import AsyncAlgorithms
import AuthSessionServiceInterface
import Foundation

/// A repository protocol for managing automatic account information updates.
///
/// This protocol defines the interface for coordinating automatic synchronization of
/// account information from the remote server to local storage. The repository handles
/// the complex orchestration of periodic updates, authentication state monitoring,
/// and data persistence.
///
/// Unlike other repositories that provide explicit methods for data operations, this
/// repository operates automatically in the background, triggered by authentication
/// events and periodic timers. It ensures that account information stays current
/// without requiring manual intervention from higher-level components.
///
/// The repository follows the repository pattern while providing a completely automated
/// approach to account data synchronization, handling network fetching, data
/// transformation, and secure storage seamlessly.
public protocol AccountUpdateRepositoryProtocol: Sendable {}

actor AccountUpdateRepository: AccountUpdateRepositoryProtocol {

    // MARK: - Properties

    private let networkService: AccountUpdateNetworkServiceProtocol
    private let persistenceService: AccountUpdatePersistenceServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private var loginObservationTask: Task<Void, Never>?
    private var timerObservationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        networkService: AccountUpdateNetworkServiceProtocol,
        persistenceService: AccountUpdatePersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.authSessionService = authSessionService

        Task { await setUpObservers() }
    }

    deinit {
        loginObservationTask?.cancel()
        timerObservationTask?.cancel()
    }

    // MARK: - Private

    private func setUpObservers() {
        timerObservationTask = Task { [weak self] in
            guard let self else { return }

            await fetchAccountInformation()

            for await _ in AsyncTimerSequence(interval: .seconds(3600), clock: .continuous) {
                await fetchAccountInformation()
            }
        }

        loginObservationTask = Task { [weak self] in
            guard let self else { return }

            if await authSessionService.isLoggedIn {
                await fetchAccountInformation()
            }

            for await isLoggedIn in authSessionService.observeLoginState() {
                if isLoggedIn {
                    await fetchAccountInformation()
                }
            }
        }
    }

    private func fetchAccountInformation() async {
        guard await authSessionService.isLoggedIn else { return }

        do {
            let accountResponse = try await networkService.fetchAccount()
            let addressesResponse = try await networkService.fetchAddresses()

            let account = Account(
                accountResponse: accountResponse,
                addressesResponse: addressesResponse
            )

            do {
                try await persistenceService.storeAccount(account)
            } catch {
                print("Failed to persist account: \(error)")
            }
        } catch {
            print("Account update failed: \(error)")
        }
    }
}

// MARK: - Private

private extension Account {

    /// Initializes an `Account` with the data from two network requests:
    /// one which returns the account information, and another one which
    /// returns the addresses associated with the user account.
    ///
    /// This initializer handles both regular addresses (with expiration dates) and
    /// lifetime addresses (without expiration dates). The optional expiration timestamp
    /// from the network response is mapped to an optional Date, with `nil` values
    /// indicating lifetime addresses that never expire.
    ///
    /// This extension is file private since no other part of the codebase
    /// needs to know how to map the network response types and the
    /// type which is persisted.
    ///
    /// - Parameters:
    ///   - accountResponse: The network model for the account information.
    ///   - addressesResponse: The network model for the addresses information, including optional expiration dates.
    init(
        accountResponse: AccountResponse,
        addressesResponse: [AddressResponse]
    ) {
        let accountDate = Date(
            timeIntervalSince1970: accountResponse.unixEpochTime.doubleValue
        )

        let addresses = addressesResponse.map { addressResponse in
            let addressDate = Date(
                timeIntervalSince1970: addressResponse.unixEpochTime.doubleValue
            )

            let expireDate = addressResponse.expireUnixEpochTime
                .map(Double.init)
                .map(Date.init(timeIntervalSince1970:))

            return Account.Address(
                address: addressResponse.address,
                creation: addressDate,
                expire: expireDate
            )
        }

        self.init(
            name: accountResponse.name,
            email: accountResponse.email,
            creation: accountDate,
            addresses: addresses
        )
    }
}
