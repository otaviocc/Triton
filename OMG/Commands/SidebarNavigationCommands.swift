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

import Route
import SwiftUI

// MARK: - FocusedValues

extension FocusedValues {

    var sidebarSelection: Binding<RouteFeature?>? {
        get { self[SidebarSelectionKey.self] }
        set { self[SidebarSelectionKey.self] = newValue }
    }
}

private struct SidebarSelectionKey: FocusedValueKey {

    typealias Value = Binding<RouteFeature?>
}

// MARK: - SidebarNavigationCommands

struct SidebarNavigationCommands: Commands {

    // MARK: - Properties

    @FocusedBinding(\.sidebarSelection) private var selection

    // MARK: - Public

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Statuslog") { selection = .statuslog }
                .keyboardShortcut("1", modifiers: .command)
            Button("PURLs") { selection = .purls }
                .keyboardShortcut("2", modifiers: .command)
            Button("Web Page") { selection = .webpage }
                .keyboardShortcut("3", modifiers: .command)
            Button("Now Page") { selection = .nowPage }
                .keyboardShortcut("4", modifiers: .command)
            Button("Weblog") { selection = .weblog }
                .keyboardShortcut("5", modifiers: .command)
            Button("Pics") { selection = .somePics }
                .keyboardShortcut("6", modifiers: .command)
            Button("Pastebin") { selection = .pastebin }
                .keyboardShortcut("7", modifiers: .command)
        }
    }
}
