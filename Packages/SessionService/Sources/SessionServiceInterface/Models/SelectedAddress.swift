import Foundation

/// A type alias representing a user's selected address string.
///
/// `SelectedAddress` is a simple string type that represents the address
/// (username) that a user has currently selected from their available addresses.
/// This typealias provides semantic meaning and type safety when working with
/// selected address values throughout the session management system.
///
/// The selected address is used throughout the application to identify the
/// active context for user operations, such as status updates, content creation,
/// or address-specific settings. By using this typealias, the code becomes more
/// self-documenting and maintains consistency across the codebase.
///
/// ## Usage Example
/// ```swift
/// let selectedAddress: SelectedAddress = "alice"
/// sessionService.setSelectedAddress(selectedAddress)
/// ```
///
/// ## Integration
/// This type integrates with the broader session management system:
/// - Used by `SessionServiceProtocol` for address selection operations
/// - Stored in `Address` enum cases to represent the selected state
/// - Part of `Session` enum associated values for complete session state
/// - Persisted by archiver systems for maintaining selection across app launches
public typealias SelectedAddress = String
