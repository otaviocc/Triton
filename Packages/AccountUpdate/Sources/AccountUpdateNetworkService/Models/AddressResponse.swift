/// A data transfer object representing address information from the network API.
///
/// This model serves as the network layer's representation of user address data,
/// specifically designed to match the API response format for address listings. It acts
/// as an intermediary between the raw network response and the application's domain models.
///
/// The `AddressResponse` uses Unix epoch time for both registration and expiration
/// timestamps to maintain compatibility with the API format, while the application
/// layer converts these to Foundation's Date type for easier date manipulation and
/// comparison operations.
///
/// ## Usage Example
/// ```swift
/// // Regular address with expiration date
/// let temporaryAddress = AddressResponse(
///     address: "alice",
///     unixEpochTime: 1640995200,
///     expireUnixEpochTime: 1672531200
/// )
///
/// // Lifetime address with no expiration
/// let lifetimeAddress = AddressResponse(
///     address: "lifetime-user",
///     unixEpochTime: 1640995200,
///     expireUnixEpochTime: nil
/// )
///
/// // Converted to domain model by repository layer
/// let address = Account.Address(
///     address: addressResponse.address,
///     creation: Date(timeIntervalSince1970: Double(addressResponse.unixEpochTime)),
///     expire: addressResponse.expireUnixEpochTime.map { Date(timeIntervalSince1970: Double($0)) }
/// )
/// ```
///
/// ## Data Flow
/// AddressResponse flows through the system as follows:
/// 1. Network service receives raw API response array
/// 2. Each response item is parsed into AddressResponse DTO
/// 3. Repository layer converts to domain Account.Address models
/// 4. Domain models are included in Account and stored in session state
public struct AddressResponse: Sendable {

    /// The address string as returned by the API (e.g., "alice").
    ///
    /// This represents the username that the user can use for communication,
    /// web presence, or other services provided by the platform.
    public let address: String

    /// The address registration timestamp in Unix epoch time format.
    ///
    /// This value represents the number of seconds since January 1, 1970 UTC
    /// when the address was originally registered by the user. The repository
    /// layer converts this to Foundation's Date type for use in the application.
    public let unixEpochTime: Int

    /// The address expiration timestamp in Unix epoch time format, if the address has an expiration date.
    ///
    /// This optional value represents the number of seconds since January 1, 1970 UTC
    /// when the address registration expires. A `nil` value indicates a lifetime address
    /// that never expires. This information is crucial for renewal management and
    /// determining address availability status. The repository layer converts this to
    /// Foundation's Date type for easier comparison with the current date.
    ///
    /// - Note: Lifetime addresses return `nil` for this property and do not require renewal.
    public let expireUnixEpochTime: Int?
}
