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
import SwiftData

/// A SwiftData model representing a tag for categorizing and organizing weblog entries.
///
/// This model stores unique tag titles that can be associated with weblog entries
/// for organization, filtering, and discovery purposes. Tags enable users to
/// group related content and facilitate content navigation through categorization.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities
/// and includes unique constraints on the tag title to prevent duplicate tags.
/// Tags are designed to be reusable across multiple weblog entries.
///
/// Usage example:
/// ```swift
/// let tag = WeblogTag(title: "swift")
/// modelContext.insert(tag)
/// ```
@Model
public final class WeblogTag {

    /// The title or label of the tag.
    ///
    /// This is the display text for the tag and serves as its unique identifier
    /// within the local database. Tag titles are case-sensitive and should be
    /// user-friendly labels that describe the category or characteristic they represent.
    public private(set) var title: String

    // MARK: - Unique constraints

    // Ensures each tag title is unique in the database.
    //
    // This constraint prevents duplicate tags from being created and ensures
    // that tag titles remain unique across all stored tags. This enables
    // consistent tag reuse and prevents fragmentation of categorization.
    #Unique<WeblogTag>([\.title])

    /// Initializes a new tag with the specified title.
    ///
    /// - Parameter title: The display text and unique identifier for the tag.
    public init(
        title: String
    ) {
        self.title = title
    }
}
