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

import DesignSystem
import Status
import SwiftUI

/// A SwiftUI view that displays the application settings interface.
///
/// This view provides a tabbed interface for managing various application settings
/// across different feature modules. It currently includes settings for the Statuslog
/// feature, with the capability to expand to additional feature settings tabs in the future.
///
/// The view uses the dependency injection container (`TritonEnvironment`) to access
/// feature-specific settings views through their respective app factories, maintaining
/// loose coupling between the main application and feature modules.
struct SettingsView: View {

    // MARK: - Properties

    private let environment: any TritonEnvironmentProtocol

    // MARK: - Lifecycle

    init(
        environment: any TritonEnvironmentProtocol
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some View {
        TabView {
            makeStatusSettingsView()
                .tabItem {
                    Label("Statuslog", systemImage: "message")
                }

            TipJarView()
                .tabItem {
                    Label("Tip Jar", systemImage: "cup.and.saucer.fill")
                }
        }
        .frame(width: 480)
    }

    // MARK: - Private

    private func makeStatusSettingsView() -> some View {
        environment
            .statusAppFactory
            .makeSettingsView()
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        environment: TritonEnvironment()
    )
}
