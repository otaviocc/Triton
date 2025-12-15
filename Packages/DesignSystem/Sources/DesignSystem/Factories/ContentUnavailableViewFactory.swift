import SwiftUI

/// Factory for creating standardized content unavailable views across the application.
public enum ContentUnavailableViewFactory {

    // MARK: - Nested types

    /// Represents different features in the application that may display empty state views.
    public enum Feature {

        /// Permanent URLs feature.
        case purls
        /// Webpage editing feature.
        case webpage
        /// Now page status feature.
        case nowPage
        /// Weblog blogging feature.
        case weblog
        /// Some Pics feature.
        case somePics
        /// Pastebin paste sharing feature.
        case pastebin
    }

    // MARK: - Public

    /// Creates a standard view for features that are not yet implemented.
    ///
    /// - Returns: A ContentUnavailableView indicating the feature is not implemented.
    public static func makeNotImplementedView() -> some View {
        ContentUnavailableView(
            "Not implemented",
            systemImage: "wrench.and.screwdriver",
            description: Text("This feature was not implemented yet.")
        )
    }

    /// Creates an empty state view for a specific feature.
    ///
    /// - Parameter feature: The feature type to create an empty state view for.
    /// - Returns: A ContentUnavailableView with feature-specific messaging and iconography.
    public static func makeEmptyFeature(_ feature: Feature) -> some View {
        ContentUnavailableView(
            "Nothing here yet",
            systemImage: feature.systemImage,
            description: Text(feature.description)
        )
    }
}

// MARK: - Private

private extension ContentUnavailableViewFactory.Feature {

    var description: String {
        switch self {
        case .purls: "Create your first permanent URL to see it listed here."
        case .webpage: "Design your webpage to make it available online."
        case .nowPage: "Add content to your now page to share what you're up to."
        case .weblog: "Start writing your first blog post to see it appear here."
        case .somePics: "Upload your first image to see it appear here."
        case .pastebin: "Create your first paste to see it appear here."
        }
    }

    var systemImage: String {
        switch self {
        case .purls: "link"
        case .webpage: "safari"
        case .nowPage: "clock"
        case .weblog: "text.below.photo"
        case .somePics: "photo"
        case .pastebin: "clipboard"
        }
    }
}
