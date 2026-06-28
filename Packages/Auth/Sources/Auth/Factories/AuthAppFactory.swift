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
import OMGAPI
import SwiftUI

/// Factory responsible for creating the authentication feature and its views.
///
/// `AuthAppFactory` manages the authentication flow including login and logout functionality.
/// It initializes the authentication environment with required dependencies and provides
/// methods to create fully configured authentication views.
///
/// ## Usage
///
/// ```swift
/// let factory = AuthAppFactory(
///     authSessionService: authSession,
///     networkClient: client
/// )
///
/// let authView = factory.makeAppView()
/// ```
public final class AuthAppFactory {

    // MARK: - Properties

    private let environment: AuthEnvironment

    // MARK: - Lifecycle

    public init(
        oauthConfiguration: OAuthClientConfiguration,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        environment = .init(
            oauthConfiguration: oauthConfiguration,
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    // MARK: - Public

    /// Creates the main authentication view.
    ///
    /// This method constructs the authentication feature's root view with all necessary
    /// dependencies injected. The view handles the complete authentication flow including
    /// login, logout, and session management.
    ///
    /// - Returns: A configured authentication view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeAuthAppViewModel()

        AuthApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
    }
}
