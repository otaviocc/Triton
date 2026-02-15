// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import AuthSessionServiceInterface
import SessionServiceInterface

/// A protocol for managing account information persistence operations.
///
/// This protocol defines the interface for storing account information in the application's
/// session state. Unlike traditional persistence services that use databases or file storage,
/// this service manages account data within the active session through the SessionService.
///
/// The service handles the integration between fetched account data and the session management
/// system, ensuring that current account information is available throughout the application.
/// It also manages automatic cleanup of account data when users log out.
///
/// All storage operations are performed on the main actor to ensure thread safety with
/// session state updates and UI synchronization.
public protocol AccountUpdatePersistenceServiceProtocol: Sendable {

    /// Stores account information in the current session.
    ///
    /// This method persists the provided account information by updating the current
    /// session with the account details. The account data becomes available throughout
    /// the application via the session service and can be accessed by UI components
    /// and other services that need account information.
    ///
    /// The account information includes user details (name, email) and associated
    /// addresses with their registration and expiration dates.
    ///
    /// - Parameter account: The account information to store in the current session.
    /// - Throws: Session-related errors if the storage operation fails.
    @MainActor
    func storeAccount(_ account: Account) async throws
}

actor AccountUpdatePersistenceService: AccountUpdatePersistenceServiceProtocol {

    // MARK: - Properties

    private let sessionService: any SessionServiceProtocol
    private let authSessionService: any AuthSessionServiceProtocol
    private var logoutObservationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.sessionService = sessionService
        self.authSessionService = authSessionService

        Task { await setUpObservers() }
    }

    deinit {
        logoutObservationTask?.cancel()
    }

    // MARK: - Public

    @MainActor
    func storeAccount(
        _ account: Account
    ) async throws {
        await sessionService
            .setCurrentAccount(
                .init(account: account)
            )
    }

    // MARK: - Private

    private func setUpObservers() async {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                await sessionService.clearSession()
            }
        }
    }
}

// MARK: - Private

private extension CurrentAccount {

    /// Initializes `CurrentAccount` from an `Account`.
    ///
    /// This extension is file private since no other part of the codebase
    /// needs to know how to map between these two types.
    ///
    /// - Parameter account: The account to be mapped.
    init(
        account: Account
    ) {
        let addresses = account.addresses
            .map { address in
                CurrentAccount.Address(
                    address: address.address,
                    creation: address.creation,
                    expire: address.expire
                )
            }

        self.init(
            name: account.name,
            email: account.email,
            creation: account.creation,
            addresses: addresses
        )
    }
}
