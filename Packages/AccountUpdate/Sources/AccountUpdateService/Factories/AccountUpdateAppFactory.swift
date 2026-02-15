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
