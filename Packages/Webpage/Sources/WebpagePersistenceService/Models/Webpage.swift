import Foundation
import SwiftData

/// A SwiftData model representing versioned webpage content stored in the local database.
///
/// This model is the persistent representation of webpage content in the app's local storage.
/// It's designed to support content versioning, offline access, and synchronization with
/// remote data. Each instance represents a specific version of webpage content at a
/// particular point in time.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities and
/// includes unique constraints based on address and timestamp to prevent duplicate versions.
/// A limited retention policy (3 most recent versions) is enforced through the fetch descriptor
/// to prevent unlimited storage growth.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<Webpage>.makeDefault()
/// let webpages = try modelContext.fetch(descriptor)
/// ```
@Model
public final class Webpage {

    // MARK: - Properties

    /// The address associated with the webpage.
    ///
    /// This identifies which webpage this content version belongs to, enabling
    /// support for multiple webpages within the same app instance. It serves
    /// as part of the composite unique key along with the timestamp.
    public private(set) var address: String

    /// The markdown content of the webpage.
    ///
    /// This contains the full webpage content in markdown format as stored locally.
    /// The content represents a specific version of the webpage at the time indicated
    /// by the timestamp. Content is preserved exactly as received from the server.
    public private(set) var markdown: String

    /// The timestamp when this webpage version was last modified.
    ///
    /// This timestamp represents the server-side modification time and is used for
    /// chronological sorting and version identification. Combined with the address,
    /// it forms a unique identifier that prevents duplicate storage of the same
    /// webpage version.
    public private(set) var timestamp: Double

    // MARK: - Unique constraints

    /// Ensures each webpage version has a unique combination of address and timestamp.
    ///
    /// This constraint prevents duplicate webpage versions from being stored and
    /// enables efficient version management. The combination of address and timestamp
    /// uniquely identifies each webpage content version in the database.
    #Unique<Webpage>([\.address, \.timestamp])

    // MARK: - Lifecycle

    /// Initializes a new webpage content version with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorableWebpage` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - address: The domain address associated with the webpage.
    ///   - markdown: The webpage content in markdown format.
    ///   - timestamp: The last modification timestamp as Unix time.
    public init(
        address: String,
        markdown: String,
        timestamp: Double
    ) {
        self.address = address
        self.markdown = markdown
        self.timestamp = timestamp
    }
}
