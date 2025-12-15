import Foundation
import SwiftData

/// A SwiftData model representing a muted keyword in the local database.
///
/// This model maintains a list of keywords that should be used to filter
/// status updates from the timeline. Status updates containing any of these
/// keywords in their content will be hidden from the timeline view.
@Model
public final class MutedKeyword {

    // MARK: - Properties

    /// The keyword or phrase to mute.
    ///
    /// This serves as the unique identifier for muted keywords in the database,
    /// ensuring that each keyword can only be muted once. Matching is case-insensitive.
    public private(set) var keyword: String

    /// The timestamp when the keyword was muted.
    ///
    /// This timestamp is used for sorting the mute list chronologically,
    /// with more recently muted keywords appearing first.
    public private(set) var mutedAt: Date

    // MARK: - Unique constraints

    /// Ensures only one mute entry per keyword is stored in the database.
    #Unique<MutedKeyword>([\.keyword])

    // MARK: - Lifecycle

    /// Initializes a new muted keyword entry.
    ///
    /// - Parameters:
    ///   - keyword: The keyword or phrase to mute.
    ///   - mutedAt: The timestamp when the keyword was muted. Defaults to current date.
    public init(
        keyword: String,
        mutedAt: Date = Date()
    ) {
        self.keyword = keyword
        self.mutedAt = mutedAt
    }
}
