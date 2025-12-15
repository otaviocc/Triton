/// Represents the state of the user's currently selected address.
///
/// The `Address` enum tracks whether a user has selected an address from their
/// available addresses for active use. It provides type-safe access to the
/// selected address, ensuring that address-dependent operations can only be
/// performed when an address is actually selected.
///
/// This model is essential for features that depend on a specific address
/// context, such as status updates, content management, or address-specific
/// settings. The enum pattern prevents common bugs related to accessing
/// address information when none is selected.
///
/// ## Usage Example
/// ```swift
/// switch address {
/// case .notSet:
///     // Prompt user to select an address
///     AddressSelectionView()
/// case .address(let selectedAddress):
///     // Proceed with address-dependent operation
///     StatusUpdateView(address: selectedAddress)
/// }
/// ```
///
/// ## State Flow
/// The address typically transitions through these states:
/// 1. `.notSet` - Initial state or when no address is selected
/// 2. `.address(current:)` - After user selects an address from available options
///
/// ## Integration
/// This enum works closely with the `CurrentAccount` model, which contains
/// the list of available addresses that users can select from.
public enum Address: Codable, Equatable, Sendable {

    /// Indicates that no address is currently selected.
    ///
    /// This case represents the state when the user hasn't selected an address
    /// from their available addresses, or when the address selection has been
    /// cleared. Operations requiring an address should prompt for selection
    /// when this state is encountered.
    case notSet

    /// Contains the currently selected address.
    ///
    /// This case holds the address string that the user has selected for
    /// active operations. This address should be one of the addresses
    /// available in the user's account information.
    ///
    /// - Parameter current: The selected address string
    case address(current: SelectedAddress)
}
