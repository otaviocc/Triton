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
