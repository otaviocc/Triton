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
