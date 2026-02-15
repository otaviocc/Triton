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

public extension ProgressView {

    /// Styles a ProgressView as a disabled toolbar button with circular progress indicator.
    ///
    /// This modifier transforms a ProgressView into a toolbar-appropriate button that displays
    /// a circular progress indicator. The resulting button is disabled and scaled down to fit
    /// nicely within toolbar contexts. This is typically used to show loading states in toolbars.
    ///
    /// - Returns: A view styled as a disabled toolbar button containing a circular progress indicator.
    ///
    /// ## Example
    /// ```swift
    /// ProgressView()
    ///     .toolbarButton()
    /// ```
    func toolbarButton() -> some View {
        modifier(
            ToolbarButtonModifier()
        )
    }
}

// MARK: - Private

private struct ToolbarButtonModifier: ViewModifier {

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        Button {} label: {
            content
                .progressViewStyle(.circular)
                .scaleEffect(0.5, anchor: .center)
        }
        .disabled(true)
    }
}
