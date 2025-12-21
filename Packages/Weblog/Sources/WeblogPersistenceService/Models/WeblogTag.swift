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

    /// Ensures each tag title is unique in the database.
    ///
    /// This constraint prevents duplicate tags from being created and ensures
    /// that tag titles remain unique across all stored tags. This enables
    /// consistent tag reuse and prevents fragmentation of categorization.
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
