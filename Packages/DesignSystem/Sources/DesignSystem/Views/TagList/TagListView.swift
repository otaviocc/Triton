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

/// A horizontally scrolling list of tag views with customizable styles and actions.
///
/// `TagListView` displays a collection of tags in a horizontal layout, automatically
/// handling scrolling when the content exceeds the available width. Each tag can be
/// styled individually and triggers an action when tapped.
///
/// # Example
/// ```swift
/// // Display suggested tags
/// TagListView(
///     tags: ["swift", "ios", "macos"],
///     helpText: { "Add tag '\($0)'" }
/// ) { selectedTag in
///     addTag(selectedTag)
/// }
///
/// // Display removable tags
/// TagListView(
///     tags: selectedTags,
///     style: .remove,
///     helpText: { "Remove '\($0)'" }
/// ) { tagToRemove in
///     removeTag(tagToRemove)
/// }
/// ```
public struct TagListView: View {

    // MARK: - Properties

    private let tags: [String]
    private let style: TagView.Style
    private let helpText: (String) -> String
    private let action: (String) -> Void

    // MARK: - Lifecycle

    /// Creates a new tag list view with the specified configuration.
    ///
    /// - Parameters:
    ///   - tags: The array of tag strings to display.
    ///   - style: The visual style for all tags. Defaults to `.regular`.
    ///   - helpText: A closure that generates tooltip text for each tag. Defaults to empty string.
    ///   - action: The action to perform when a tag is tapped, receiving the tag string as a parameter.
    public init(
        tags: [String],
        style: TagView.Style = .regular,
        helpText: @escaping (String) -> String = { _ in "" },
        action: @escaping @MainActor (String) -> Void
    ) {
        self.tags = tags
        self.style = style
        self.helpText = helpText
        self.action = action
    }

    // MARK: - Public

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    TagView(title: tag, style: style) {
                        action(tag)
                    }
                    .help(helpText(tag))
                }
            }
        }
        .frame(maxHeight: 32)
    }
}

// MARK: - Preview

#Preview("Regular Tags") {
    TagListView(
        tags: ["swift", "ios", "macos"],
        helpText: { "Select \($0)" },
        action: { _ in }
    )
}

#Preview("Remove Tags") {
    TagListView(
        tags: ["swift", "ios", "macos"],
        style: .remove,
        helpText: { "Remove \($0)" },
        action: { _ in }
    )
}
