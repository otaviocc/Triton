import SwiftUI

public extension AsyncImage {

    /// Styles an AsyncImage as a large rounded icon with consistent dimensions.
    ///
    /// This modifier formats the AsyncImage to display as a circular icon by setting it to a
    /// 64x64 point size and applying a corner radius of 32 points (making it perfectly circular).
    /// This creates a consistent appearance for app icons or profile images throughout the application.
    ///
    /// - Returns: A view styled as a circular icon with standard large dimensions.
    ///
    /// ## Example
    /// ```swift
    /// AsyncImage(url: URL(string: "https://example.com/icon.png"))
    ///     .roundedIcon()
    /// ```
    func roundedIcon() -> some View {
        modifier(RoundIconModifier())
    }
}

// MARK: - Private

private struct RoundIconModifier: ViewModifier {

    func body(
        content: Content
    ) -> some View {
        content
            .frame(width: 64, height: 64)
            .clipShape(.rect(cornerRadius: 32))
    }
}
