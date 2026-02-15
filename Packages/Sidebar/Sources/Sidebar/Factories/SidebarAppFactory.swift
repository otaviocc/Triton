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
import Route
import SwiftUI

/// Factory responsible for creating the sidebar navigation feature and its views.
///
/// `SidebarAppFactory` manages the application's sidebar navigation including feature
/// selection and routing. It initializes the sidebar environment with required dependencies
/// and provides methods to create fully configured sidebar views.
///
/// ## Usage
///
/// ```swift
/// let factory = SidebarAppFactory(
///     authSessionService: authSession
/// )
///
/// let sidebarView = factory.makeAppView(selection: $selectedFeature)
/// ```
public final class SidebarAppFactory {

    // MARK: - Properties

    private let environment: SidebarEnvironment

    // MARK: - Lifecycle

    public init(
        authSessionService: any AuthSessionServiceProtocol
    ) {
        environment = .init(
            authSessionService: authSessionService
        )
    }

    // MARK: - Public

    /// Creates the main sidebar navigation view.
    ///
    /// This method constructs the sidebar navigation view with all necessary dependencies
    /// injected. The view displays available features and manages navigation selection.
    ///
    /// - Parameter selection: A binding to the currently selected route feature.
    /// - Returns: A configured sidebar view ready for presentation.
    @MainActor
    public func makeAppView(
        selection: Binding<RouteFeature?>
    ) -> some View {
        let viewModel = environment.viewModelFactory
            .makeSidebarViewModel()

        return SidebarView(
            viewModel: viewModel,
            selection: selection
        )
    }
}
