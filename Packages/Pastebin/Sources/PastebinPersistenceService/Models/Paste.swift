import Foundation
import SwiftData

/// A SwiftData model representing a text paste stored in the local database.
///
/// This model is the persistent representation of text pastes in the app's local storage.
/// It's designed to maintain a complete collection of user's pastes for offline access
/// and management. Each paste represents a text snippet with configurable visibility
/// and metadata about when it was last modified.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities and
/// includes unique constraints on the combination of address and title to prevent duplicate
/// pastes within a user's collection. All properties are publicly readable but privately
/// settable to maintain data integrity.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<Paste>.makeDefault()
/// let pastes = try modelContext.fetch(descriptor)
/// ```
@Model
public final class Paste {

    // MARK: - Properties

    /// The unique title/identifier of the paste.
    ///
    /// This serves as the unique identifier and human-readable name for the
    /// paste within the user's address. It must be unique within the address
    /// scope and is used for referencing, updating, and deleting the paste
    /// in both UI components and database operations.
    public private(set) var title: String

    /// The text content of the paste.
    ///
    /// This contains the actual text content stored in the paste. It can be
    /// any text content including code snippets, notes, configuration files,
    /// or other text-based information. The content is stored locally to enable
    /// offline access to paste data.
    public private(set) var content: String

    /// The timestamp when the paste was last modified.
    ///
    /// This represents the server-side modification time and is used for
    /// chronological sorting and displaying when pastes were last updated.
    /// It's stored as a Double for efficient date calculations and sorting operations.
    public private(set) var timestamp: Double

    /// The address associated with the paste.
    ///
    /// This identifies which user address the paste belongs to, enabling support
    /// for multiple addresses within the same app instance. It serves as part
    /// of the composite unique key along with the paste title.
    public private(set) var address: String

    /// The visibility status of the paste.
    ///
    /// This boolean indicates whether the paste is publicly visible (true)
    /// or private (false). Public pastes may be discoverable by others,
    /// while private pastes are only accessible to the owner. The visibility
    /// setting is preserved locally for offline paste management.
    public private(set) var listed: Bool

    // MARK: - Unique constraints

    /// Ensures each paste has a unique combination of address and title.
    ///
    /// This constraint prevents duplicate pastes from being stored and ensures
    /// that each paste title is unique within a user's address. The combination
    /// of address and title uniquely identifies each paste in the database,
    /// supporting multi-address paste management.
    #Unique<Paste>([\.address, \.title])

    // MARK: - Lifecycle

    /// Initializes a new paste with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorablePaste` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - title: The unique title/identifier for the paste.
    ///   - content: The text content of the paste.
    ///   - timestamp: The last modification timestamp as Unix time.
    ///   - address: The user address associated with the paste.
    ///   - listed: Whether the paste is publicly visible (true) or private (false).
    public init(
        title: String,
        content: String,
        timestamp: Double,
        address: String,
        listed: Bool
    ) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.address = address
        self.listed = listed
    }
}
