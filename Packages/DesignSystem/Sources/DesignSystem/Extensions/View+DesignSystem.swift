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
