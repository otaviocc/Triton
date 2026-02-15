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

/// Defines how a view should expand to fill available space.
public enum FrameExpansion {

    /// Expands the view to fill all available space horizontally and vertically.
    case full
    /// Expands the view to fill all available space horizontally only.
    case horizontally
    /// Expands the view to fill all available space vertically only.
    case vertically

    fileprivate var width: CGFloat? {
        switch self {
        case .full, .horizontally: .infinity
        case .vertically: nil
        }
    }

    fileprivate var height: CGFloat? {
        switch self {
        case .full, .vertically: .infinity
        case .horizontally: nil
        }
    }
}

public extension View {

    /// Applies frame expansion to the view based on the specified expansion type.
    ///
    /// This method provides a convenient way to set a view's maximum width and/or height
    /// to infinity, allowing it to expand to fill available space in the specified direction(s).
    ///
    /// - Parameter expansion: The type of expansion to apply (full, horizontal, or vertical).
    /// - Returns: A view with the specified frame expansion applied.
    func frame(
        _ expansion: FrameExpansion
    ) -> some View {
        modifier(
            ExpandedFrameModifier(
                expansion: expansion
            )
        )
    }
}

// MARK: - Private

private struct ExpandedFrameModifier: ViewModifier {

    // MARK: - Properties

    private let expansion: FrameExpansion

    // MARK: - Lifecycle

    init(
        expansion: FrameExpansion
    ) {
        self.expansion = expansion
    }

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        content
            .frame(
                maxWidth: expansion.width,
                maxHeight: expansion.height
            )
    }
}
