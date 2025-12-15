import SwiftUI

/// A view that displays a favicon for a given URL.
///
/// `FaviconView` fetches and displays a website's favicon using Google's favicon service.
/// If the URL is invalid or the favicon cannot be loaded, a fallback link icon is displayed.
public struct FaviconView: View {

    // MARK: - Properties

    private let iconURL: URL?

    // MARK: - Lifecycle

    /// Creates a favicon view for the specified URL.
    ///
    /// - Parameter url: The URL of the website whose favicon should be displayed.
    ///   If `nil`, a fallback icon will be shown.
    public init(
        url: URL?
    ) {
        iconURL = url.flatMap {
            URL(string: "https://www.google.com/s2/favicons?sz=16&domain=\($0.absoluteString)")
        }
    }

    // MARK: - Public

    public var body: some View {
        AsyncImage(
            url: iconURL,
            content: { image in
                image
            },
            placeholder: {
                Image(systemName: "link")
            }
        )
        .roundedFavicon()
    }
}

// MARK: - Preview

#Preview("Valid URL") {
    FaviconView(url: URL(string: "otavio.cc"))
}

#Preview("Invalid URL") {
    FaviconView(url: nil)
}
