import SwiftUI

public extension AsyncImage {

    /// Styles an AsyncImage as a rounded favicon with consistent dimensions.
    ///
    /// This modifier formats the AsyncImage to display as a favicon by setting it to a
    /// 16x16 point size and applying rounded corners with a 4-point radius. This creates
    /// a consistent appearance for website favicons throughout the application.
    ///
    /// - Returns: A view styled as a rounded favicon with standard dimensions.
    ///
    /// ## Example
    /// ```swift
    /// AsyncImage(url: URL(string: "https://example.com/favicon.ico"))
    ///     .roundedFavicon()
    /// ```
    func roundedFavicon() -> some View {
        modifier(RoundFaviconModifier())
    }
}

// MARK: - Private

private struct RoundFaviconModifier: ViewModifier {

    func body(
        content: Content
    ) -> some View {
        content
            .frame(width: 16, height: 16)
            .clipShape(.rect(cornerRadius: 4))
    }
}
