import SwiftData

/// A SwiftData model representing a /now page stored in the local database.
///
/// This model is the persistent representation of /now pages in the app's local storage.
/// It's designed to support versioned content history, offline access, and synchronization
/// with remote data. Each instance represents a specific version of a /now page at a
/// particular point in time.
///
/// The /now page is a concept from nownownow.com where people share what they're currently
/// focused on in their lives. The model uses SwiftData's `@Model` macro for automatic
/// persistence capabilities and includes unique constraints based on address and timestamp
/// to prevent duplicate versions. A limited retention policy (3 most recent versions) is
/// enforced to prevent unlimited storage growth.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<Now>.makeDefault()
/// let nowPages = try modelContext.fetch(descriptor)
/// ```
@Model
public final class Now {

    // MARK: - Properties

    /// Whether the /now page is listed in public directories or "gardens."
    ///
    /// This boolean indicates the visibility status of the /now page. When true,
    /// the page is publicly discoverable in directories or "gardens." When false,
    /// it remains private to the owner. This setting affects how others can
    /// discover and view the /now page content.
    public private(set) var listed: Bool

    /// The markdown content of the /now page.
    ///
    /// This contains the full /now page content in markdown format, representing
    /// what the person is currently focused on in their life. The content includes
    /// current projects, thoughts, or life focus areas and is stored locally to
    /// enable offline access and editing capabilities.
    public private(set) var markdown: String

    /// Whether the /now page has been synchronized with the remote server.
    ///
    /// This boolean tracks the synchronization state of the /now page version:
    /// - true: The content has been successfully submitted/synchronized with the server
    /// - false: The content is saved locally but may not be synchronized with the server
    ///
    /// This enables offline editing capabilities and helps track sync status.
    public private(set) var submitted: Bool

    /// The timestamp when this /now page version was last modified.
    ///
    /// This represents the server-side modification time and is used for
    /// chronological sorting and version identification. Combined with the address,
    /// it forms a unique identifier that prevents duplicate storage of the same
    /// /now page version.
    public private(set) var timestamp: Double

    /// The address associated with this /now page.
    ///
    /// This identifies which user address the /now page belongs to, enabling
    /// support for multiple addresses within the same app instance. It serves
    /// as part of the composite unique key along with the timestamp.
    public private(set) var address: String

    // MARK: - Unique constraints

    /// Ensures each /now page version has a unique combination of address and timestamp.
    ///
    /// This constraint prevents duplicate /now page versions from being stored and
    /// enables efficient version management. The combination of address and timestamp
    /// uniquely identifies each /now page content version in the database.
    #Unique<Now>([\.address, \.timestamp])

    // MARK: - Lifecycle

    /// Initializes a new /now page version with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorableNow` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - listed: Whether the /now page is publicly visible in directories.
    ///   - markdown: The /now page content in markdown format.
    ///   - submitted: Whether the content has been synchronized with the server.
    ///   - timestamp: The last modification timestamp as Unix time.
    ///   - address: The user address associated with the /now page.
    public init(
        listed: Bool,
        markdown: String,
        submitted: Bool,
        timestamp: Double,
        address: String
    ) {
        self.listed = listed
        self.markdown = markdown
        self.submitted = submitted
        self.timestamp = timestamp
        self.address = address
    }
}
