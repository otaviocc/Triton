import Foundation
import SwiftData

/// A SwiftData model representing a Permanent URL (PURL) stored in the local database.
///
/// This model is the persistent representation of PURLs in the app's local storage.
/// It's designed to maintain a complete collection of user's PURLs for offline access
/// and management. Each PURL represents a short, memorable redirect that points to
/// a longer target URL.
///
/// The model uses SwiftData's `@Model` macro for automatic persistence capabilities and
/// includes unique constraints on the combination of address and name to prevent duplicate
/// PURLs within a user's collection. All properties are publicly readable but privately
/// settable to maintain data integrity.
///
/// Usage example:
/// ```swift
/// let descriptor = FetchDescriptor<PURL>.makeDefault()
/// let purls = try modelContext.fetch(descriptor)
/// ```
@Model
public final class PURL {

    // MARK: - Properties

    /// The unique name/identifier of the PURL.
    ///
    /// This serves as the permanent identifier and URL path component for the
    /// redirect. It must be unique within the user's address and is used to
    /// construct the final permanent URL. The name should be short, memorable,
    /// and URL-safe for optimal user experience.
    public private(set) var name: String

    /// The target URL that the PURL redirects to.
    ///
    /// This is the destination URL where users will be redirected when accessing
    /// the permanent URL. It can be any valid URL and is stored locally to enable
    /// offline viewing of PURL configurations and management operations.
    public private(set) var url: URL

    /// The hostname extracted from the target URL.
    ///
    /// This property stores the host component of the target URL for convenient
    /// access and display purposes. It's automatically extracted during initialization
    /// and enables efficient filtering, grouping, and presentation of PURLs by their
    /// destination domain without repeatedly parsing the full URL.
    public private(set) var hostname: String

    /// The address associated with the PURL.
    ///
    /// This identifies which user address the PURL belongs to, enabling support
    /// for multiple addresses within the same app instance. It serves as part
    /// of the composite unique key along with the PURL name.
    public private(set) var address: String

    // MARK: - Unique constraints

    /// Ensures each PURL has a unique combination of address and name.
    ///
    /// This constraint prevents duplicate PURLs from being stored and ensures
    /// that each PURL name is unique within a user's address. The combination
    /// of address and name uniquely identifies each PURL in the database,
    /// supporting multi-address PURL management.
    #Unique<PURL>([\.address, \.name])

    // MARK: - Lifecycle

    /// Initializes a new PURL with all required data.
    ///
    /// This initializer is typically used by the persistence service when
    /// converting from `StorablePURL` objects during data synchronization.
    ///
    /// - Parameters:
    ///   - name: The unique name/identifier for the PURL.
    ///   - url: The target URL that the PURL redirects to.
    ///   - address: The user address associated with the PURL.
    public init(
        name: String,
        url: URL,
        address: String
    ) {
        self.name = name
        self.url = url
        self.address = address
        hostname = url.host ?? ""
    }
}
