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
import ClipboardService
import MicroClient
import SessionServiceInterface
import SwiftUI

/// Factory responsible for creating the PURLs (Permanent URLs) feature and its views.
///
/// `PURLsAppFactory` manages the PURL functionality including listing, creating, and managing
/// permanent URL redirects. It initializes the PURL environment with required dependencies
/// and provides methods to create fully configured PURL views.
///
/// ## Usage
///
/// ```swift
/// let factory = PURLsAppFactory(
///     networkClient: client,
///     authSessionService: authSession,
///     sessionService: sessionService
/// )
///
/// let purlsView = factory.makeAppView()
/// ```
public final class PURLsAppFactory {

    // MARK: - Properties

    private let environment: PURLsEnvironment

    // MARK: - Lifecycle

    public init(
        networkClient: NetworkClientProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        environment = .init(
            networkClient: networkClient,
            authSessionService: authSessionService,
            sessionService: sessionService,
            clipboardService: clipboardService
        )
    }

    // MARK: - Public

    /// Creates the main PURLs feature view.
    ///
    /// This method constructs the PURLs feature's root view with all necessary
    /// dependencies injected. The view displays the list of permanent URLs and provides
    /// access to creation and management functionality.
    ///
    /// - Returns: A configured PURLs view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makePURLsAppViewModel()

        PURLsApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates the add PURL scene.
    ///
    /// This method constructs a scene for creating permanent URLs in a dedicated window.
    /// The scene provides keyboard shortcut support (Shift+Cmd+U) for quick access.
    ///
    /// - Returns: A configured scene for PURL creation.
    @MainActor
    public func makeScene() -> some Scene {
        AddPURLScene(environment: environment)
    }
}
