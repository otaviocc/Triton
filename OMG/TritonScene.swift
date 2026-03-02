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

import AccountUpdateService
import Route
import Shortcuts
import SwiftUI

/// The primary scene that provides the main application window.
///
/// This scene creates the main application window with a navigation split view containing
/// a sidebar for feature selection and a detail view for the selected feature content.
/// It manages the application's primary navigation and integrates account update services.
struct TritonScene: Scene {

    // MARK: - Properties

    @State private var selection: RouteFeature? = .statuslog
    @Environment(\.openWindow) private var openWindow

    private let environment: any TritonEnvironmentProtocol

    // MARK: - Lifecycle

    init(
        environment: any TritonEnvironmentProtocol
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            MainWindow.name,
            id: MainWindow.id
        ) {
            NavigationSplitView(
                sidebar: { makeSidebarView() },
                detail: { makeDetailView() }
            )
            #if os(macOS)
            .navigationTitle("Triton")
            #endif
            .focusedValue(\.sidebarSelection, $selection)
            .environment(makeAccountUpdateService())
            .handlesExternalEvents(
                preferring: ["viewer"],
                allowing: ["*"]
            )
            .onAppear {
                environment
                    .shortcutsService
                    .setUpObservers(openWindow: openWindow)
            }
        }
        .commandsRemoved()
    }

    // MARK: - Private

    @ViewBuilder
    private func makeSidebarView() -> some View {
        environment.sidebarAppFactory
            .makeAppView(selection: $selection)
        #if os(macOS)
            .navigationSplitViewColumnWidth(
                min: 150,
                ideal: 150,
                max: 200
            )
        #endif
    }

    @ViewBuilder
    private func makeDetailView() -> some View {
        DetailView(
            environment: environment,
            selectedFeature: $selection
        )
        #if os(macOS)
        .frame(minWidth: 320, idealWidth: 480)
        #endif
    }

    private func makeAccountUpdateService() -> AccountUpdateService {
        environment.accountUpdateAppFactory
            .makeAccountUpdateService()
    }
}
