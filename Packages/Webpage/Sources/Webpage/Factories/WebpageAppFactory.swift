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
import SwiftData
import SwiftUI

/// Factory responsible for creating the Webpage feature and its views.
///
/// `WebpageAppFactory` manages the personal webpage functionality including viewing
/// and editing the user's webpage content. It initializes the webpage environment
/// with required dependencies and provides methods to create fully configured webpage views.
///
/// ## Usage
///
/// ```swift
/// let factory = WebpageAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let webpageView = factory.makeAppView()
/// ```
public final class WebpageAppFactory {

    // MARK: - Properties

    private let environment: WebpageEnvironment

    // MARK: - Lifecycle

    public init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        environment = .init(
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService
        )
    }

    // MARK: - Public

    /// Creates the main Webpage feature view.
    ///
    /// This method constructs the webpage feature's root view with all necessary
    /// dependencies injected. The view displays the current webpage content and provides
    /// access to editing functionality.
    ///
    /// - Returns: A configured webpage view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .webpageAppViewModel()

        WebpageApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the edit webpage scene.
    ///
    /// This method constructs a scene for editing webpage content in a dedicated window.
    /// The scene allows users to update their webpage HTML content.
    ///
    /// - Returns: A configured scene for webpage editing.
    @MainActor
    public func makeScene() -> some Scene {
        EditWebpageScene(environment: environment)
    }
}
