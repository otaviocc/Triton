import Foundation
import SwiftData

/// A SwiftData model representing a muted address in the local database.
///
/// This model maintains a list of addresses that should be filtered from
/// the status timeline. Users can add addresses to this list to prevent
/// their status updates from appearing in the timeline view.
@Model
public final class MutedAddress {

    // MARK: - Properties

    /// The address of the muted user.
    ///
    /// This serves as the unique identifier for muted addresses in the database,
    /// ensuring that each address can only be muted once.
    public private(set) var address: String

    /// The timestamp when the address was muted.
    ///
    /// This timestamp is used for sorting the mute list chronologically,
    /// with more recently muted addresses appearing first.
    public private(set) var mutedAt: Date

    // MARK: - Unique constraints

    /// Ensures only one mute entry per address is stored in the database.
    #Unique<MutedAddress>([\.address])

    // MARK: - Lifecycle

    /// Initializes a new muted address entry.
    ///
    /// - Parameters:
    ///   - address: The address to mute.
    ///   - mutedAt: The timestamp when the address was muted. Defaults to current date.
    public init(
        address: String,
        mutedAt: Date = Date()
    ) {
        self.address = address
        self.mutedAt = mutedAt
    }
}
