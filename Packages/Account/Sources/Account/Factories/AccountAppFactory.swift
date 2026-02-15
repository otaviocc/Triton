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
import MicroClient
import SessionServiceInterface
import SwiftUI

/// Factory responsible for creating the account management feature and its views.
///
/// `AccountAppFactory` manages the account information display including user details,
/// addresses, and account settings. It initializes the account environment with required
/// dependencies and provides methods to create fully configured account views.
///
/// ## Usage
///
/// ```swift
/// let factory = AccountAppFactory(
///     sessionService: sessionService
/// )
///
/// let accountView = factory.makeAppView()
/// ```
public final class AccountAppFactory {

    // MARK: - Properties

    private let environment: AccountEnvironment

    // MARK: - Lifecycle

    public init(
        sessionService: any SessionServiceProtocol
    ) {
        environment = .init(
            sessionService: sessionService
        )
    }

    // MARK: - Public

    /// Creates the main account management view.
    ///
    /// This method constructs the account feature's root view with all necessary
    /// dependencies injected. The view displays user account information including
    /// email, addresses, registration date, and address management capabilities.
    ///
    /// - Returns: A configured account view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeAccountViewModel()

        AccountView(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
    }
}
