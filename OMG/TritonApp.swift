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

import SwiftUI

/// The main application entry point for OMG.
///
/// `TritonApp` configures and manages all scenes in the application, including:
/// - Main window with primary navigation
/// - Feature-specific composition scenes (Status, PURLs, Web Page, Now Page, Weblog, Pics, Pastebin)
/// - Application settings
///
/// All scenes share a single `TritonEnvironment` instance for dependency injection.
@main
struct TritonApp: App {

    // MARK: - Properties

    private let environment = TritonEnvironment()

    // MARK: - Public

    var body: some Scene {
        // Main scene

        TritonScene(
            environment: environment
        )

        // Feature scenes

        environment
            .statusAppFactory
            .makeScene()

        environment
            .purlsAppFactory
            .makeScene()

        environment
            .webpageAppFactory
            .makeScene()

        environment
            .nowAppFactory
            .makeScene()

        environment
            .weblogAppFactory
            .makeScene()

        environment
            .picsAppFactory
            .makeScene()

        environment
            .pastebinAppFactory
            .makeScene()

        // Settings

        #if os(macOS)
            Settings {
                SettingsView(
                    environment: environment
                )
            }
        #endif
    }
}
