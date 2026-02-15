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

/// Factory responsible for creating the Statuslog feature and its views.
///
/// `StatusAppFactory` manages the statuslog functionality including viewing the timeline,
/// posting status updates, and managing statuslog settings. It initializes the statuslog
/// environment with required dependencies and provides methods to create fully configured
/// statuslog views.
///
/// ## Usage
///
/// ```swift
/// let factory = StatusAppFactory(
///     sessionService: sessionService,
///     authSessionService: authSession,
///     networkClient: client
/// )
///
/// let statusView = factory.makeAppView()
/// ```
public final class StatusAppFactory {

    // MARK: - Properties

    private let environment: StatusEnvironment

    // MARK: - Lifecycle

    public init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol,
        clipboardService: any ClipboardServiceProtocol
    ) {
        environment = .init(
            sessionService: sessionService,
            authSessionService: authSessionService,
            networkClient: networkClient,
            clipboardService: clipboardService
        )
    }

    // MARK: - Public

    /// Creates the main Statuslog feature view.
    ///
    /// This method constructs the statuslog feature's root view with all necessary
    /// dependencies injected. The view displays the status timeline and provides
    /// access to posting and managing status updates.
    ///
    /// - Returns: A configured statuslog view ready for presentation.
    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeStatusAppViewModel()

        StatusApp(
            viewModel: viewModel
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(environment.modelContainer)
    }

    /// Creates a statuslog settings view.
    ///
    /// This method constructs a view for managing statuslog settings and preferences.
    /// The view allows users to configure their statuslog behavior and appearance.
    ///
    /// - Returns: A configured statuslog settings view.
    @MainActor
    @ViewBuilder
    public func makeSettingsView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeStatusSettingsViewModel()

        StatusSettingsView(
            viewModel: viewModel
        )
        .modelContainer(environment.modelContainer)
    }

    /// Creates the compose status scene.
    ///
    /// This method constructs a scene for composing status updates in a dedicated window.
    /// The scene provides keyboard shortcut support (Shift+Cmd+S) for quick access.
    ///
    /// - Returns: A configured scene for status composition.
    @MainActor
    public func makeScene() -> some Scene {
        ComposeStatusScene(environment: environment)
    }
}
