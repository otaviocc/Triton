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

/// A toolbar item that displays a circular progress indicator.
///
/// `ProgressToolbarItem` provides a consistent progress indicator for toolbars across the application.
/// It uses the `.toolbarButton()` modifier to ensure proper styling and disabled state.
///
/// ## Usage
///
/// ```swift
/// .toolbar {
///     ToolbarItemGroup {
///         if isLoading {
///             ProgressToolbarItem()
///         }
///         // Other toolbar items...
///     }
/// }
/// ```
///
/// - Note: This component is automatically disabled and styled to fit toolbar contexts.
public struct ProgressToolbarItem: View {

    // MARK: - Lifecycle

    /// Creates a progress toolbar item.
    public init() {}

    // MARK: - Public

    public var body: some View {
        ProgressView()
            .toolbarButton()
    }
}

// MARK: - Preview

#Preview {
    ProgressToolbarItem()
}
