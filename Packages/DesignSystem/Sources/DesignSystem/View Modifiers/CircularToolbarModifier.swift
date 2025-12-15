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
