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

import Foundation
import SwiftUI

/// A button-styled tag component that displays a label with optional icons.
///
/// `TagView` provides a consistent visual representation for tags throughout the app.
/// It supports two styles: regular (with leading tag icon) and remove (with trailing X icon).
///
/// # Example
/// ```swift
/// // Regular tag
/// TagView(title: "swift") {
///     print("Tag tapped")
/// }
///
/// // Remove-style tag
/// TagView(title: "swift", style: .remove) {
///     removeTag("swift")
/// }
/// ```
public struct TagView: View {

    // MARK: - Nested types

    /// Visual style options for the tag view.
    public enum Style {

        /// Regular style with a leading tag icon.
        case regular

        /// Remove style with a trailing X icon for deletion actions.
        case remove
    }

    // MARK: - Properties

    private let title: String
    private let style: Style
    private let action: () -> Void

    // MARK: - Lifecycle

    /// Creates a new tag view with the specified configuration.
    ///
    /// - Parameters:
    ///   - title: The text label to display on the tag.
    ///   - style: The visual style of the tag. Defaults to `.regular`.
    ///   - action: The action to perform when the tag is tapped.
    public init(
        title: String,
        style: Style = .regular,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    // MARK: - Public

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                if style == .regular {
                    Image(systemName: "tag")
                }
                Text(title)
                if style == .remove {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Preview

#Preview("Regular Tag") {
    TagView(
        title: "some-tag"
    ) {}
}

#Preview("Remove Tag") {
    TagView(
        title: "some-tag",
        style: .remove
    ) {}
}
