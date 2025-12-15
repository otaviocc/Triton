import Archiver
import Foundation
import SessionServiceInterface

actor SessionService: SessionServiceProtocol {

    // MARK: - Properties

    var account: Account {
        get async { _account }
    }

    var address: Address {
        get async { _address }
    }

    private var _account: Account = .notSynchronized
    private var _address: Address = .notSet
    private var accountContinuations: [UUID: AsyncStream<Account>.Continuation] = [:]
    private var addressContinuations: [UUID: AsyncStream<Address>.Continuation] = [:]
    private var sessionContinuations: [UUID: AsyncStream<Session>.Continuation] = [:]
    private let accountArchiver: Archiver<CurrentAccount>
    private let addressArchiver: Archiver<SelectedAddress>

    // MARK: - Lifecycle

    init(
        accountArchiver: Archiver<CurrentAccount>,
        addressArchiver: Archiver<SelectedAddress>
    ) {
        self.accountArchiver = accountArchiver
        self.addressArchiver = addressArchiver

        Task {
            await fetchAccountFromArchiver()
            await fetchAddressFromArchiver()
        }
    }

    // MARK: - Public

    func clearSession() async {
        await removeCurrentAccount()
        await removeSelectedAddress()
    }

    func setCurrentAccount(
        _ currentAccount: CurrentAccount
    ) async {
        do {
            try await accountArchiver.archiveItem(currentAccount)
            _account = .account(current: currentAccount)

            broadcastAccount(_account)
            broadcastSession()

            await updateAddressIfNecessary(currentAccount: currentAccount)
        } catch {
            await removeCurrentAccount()
            await removeSelectedAddress()
        }
    }

    nonisolated func observeAccount() -> AsyncStream<Account> {
        let id = UUID()

        return .init { continuation in
            Task { [weak self] in
                await self?.addAccountObserver(id: id, continuation: continuation)
            }

            continuation.onTermination = { @Sendable [weak self] _ in
                Task { await self?.removeAccountObserver(id) }
            }
        }
    }

    nonisolated func observeAddress() -> AsyncStream<Address> {
        let id = UUID()

        return .init { continuation in
            Task { [weak self] in
                await self?.addAddressObserver(id: id, continuation: continuation)
            }

            continuation.onTermination = { @Sendable [weak self] _ in
                Task { await self?.removeAddressObserver(id) }
            }
        }
    }

    func setSelectedAddress(
        _ currentAddress: SelectedAddress
    ) async {
        do {
            try await addressArchiver.archiveItem(currentAddress)
            _address = .address(current: currentAddress)

            broadcastAddress(_address)
            broadcastSession()
        } catch {
            await removeSelectedAddress()
        }
    }

    nonisolated func observeSession() -> AsyncStream<Session> {
        let id = UUID()

        return .init { continuation in
            Task { [weak self] in
                await self?.addSessionObserver(id: id, continuation: continuation)
            }

            continuation.onTermination = { @Sendable [weak self] _ in
                Task { await self?.removeSessionObserver(id) }
            }
        }
    }

    // MARK: - Private

    private func computeSession() -> Session {
        switch (_account, _address) {
        case let (.account(currentAccount), .address(selectedAddress)):
            .session(account: currentAccount, selectedAddress: selectedAddress)
        default:
            .notAvailable
        }
    }

    private func broadcastAccount(
        _ account: Account
    ) {
        for continuation in accountContinuations.values {
            continuation.yield(account)
        }
    }

    private func broadcastAddress(
        _ address: Address
    ) {
        for continuation in addressContinuations.values {
            continuation.yield(address)
        }
    }

    private func broadcastSession() {
        let session = computeSession()
        for continuation in sessionContinuations.values {
            continuation.yield(session)
        }
    }

    private func addAccountObserver(
        id: UUID,
        continuation: AsyncStream<Account>.Continuation
    ) {
        accountContinuations[id] = continuation
        continuation.yield(_account)
    }

    private func addAddressObserver(
        id: UUID,
        continuation: AsyncStream<Address>.Continuation
    ) {
        addressContinuations[id] = continuation
        continuation.yield(_address)
    }

    private func addSessionObserver(
        id: UUID,
        continuation: AsyncStream<Session>.Continuation
    ) {
        sessionContinuations[id] = continuation
        continuation.yield(computeSession())
    }

    private func removeAccountObserver(
        _ id: UUID
    ) {
        accountContinuations.removeValue(forKey: id)
    }

    private func removeAddressObserver(
        _ id: UUID
    ) {
        addressContinuations.removeValue(forKey: id)
    }

    private func removeSessionObserver(
        _ id: UUID
    ) {
        sessionContinuations.removeValue(forKey: id)
    }

    private func updateAddressIfNecessary(
        currentAccount: CurrentAccount
    ) async {
        guard
            _address == .notSet,
            let firstAddress = currentAccount.addresses.first
        else {
            return
        }

        _address = .address(current: firstAddress.address)

        broadcastAddress(_address)
        broadcastSession()
    }

    private func fetchAccountFromArchiver() async {
        do {
            let currentAccount = try await accountArchiver.unarchiveItem()
            _account = .account(current: currentAccount)

            broadcastAccount(_account)
            broadcastSession()
        } catch {
            _account = .notSynchronized

            broadcastAccount(_account)
            broadcastSession()
        }
    }

    private func fetchAddressFromArchiver() async {
        do {
            let currentAddress = try await addressArchiver.unarchiveItem()
            _address = .address(current: currentAddress)

            broadcastAddress(_address)
            broadcastSession()
        } catch {
            _address = .notSet

            broadcastAddress(_address)
            broadcastSession()
        }
    }

    private func removeCurrentAccount() async {
        try? await accountArchiver.clearArchive()

        _account = .notSynchronized

        broadcastAccount(_account)
        broadcastSession()
    }

    private func removeSelectedAddress() async {
        try? await addressArchiver.clearArchive()

        _address = .notSet

        broadcastAddress(_address)
        broadcastSession()
    }
}
