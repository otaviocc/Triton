/// A data transfer object representing account information from the network API.
///
/// This model serves as the network layer's representation of user account data,
/// specifically designed to match the API response format. It acts as an intermediary
/// between the raw network response and the application's domain models.
///
/// The `AccountResponse` uses Unix epoch time for the creation timestamp to maintain
/// compatibility with the API format, while the application layer converts this to
/// Foundation's Date type for easier manipulation.
///
/// ## Usage Example
/// ```swift
/// // Typically created by the network service when parsing API responses
/// let accountResponse = AccountResponse(
///     email: "user@example.com",
///     name: "John Doe",
///     unixEpochTime: 1640995200
/// )
///
/// // Converted to domain model by repository layer
/// let account = Account(
///     name: accountResponse.name,
///     email: accountResponse.email,
///     creation: Date(timeIntervalSince1970: Double(accountResponse.unixEpochTime)),
///     addresses: []
/// )
/// ```
///
/// ## Data Flow
/// AccountResponse flows through the system as follows:
/// 1. Network service receives raw API response
/// 2. Response is parsed into AccountResponse DTO
/// 3. Repository layer converts to domain Account model
/// 4. Domain model is stored in session state
public struct AccountResponse: Sendable {

    /// The user's email address as returned by the API.
    ///
    /// This represents the primary email associated with the user's account
    /// and is used for identification and communication purposes.
    public let email: String

    /// The user's display name as returned by the API.
    ///
    /// This is how the user identifies themselves within the service
    /// and appears in various UI elements throughout the application.
    public let name: String

    /// The account creation timestamp in Unix epoch time format.
    ///
    /// This value represents the number of seconds since January 1, 1970 UTC
    /// when the user's account was originally created. The repository layer
    /// converts this to Foundation's Date type for use in the application.
    public let unixEpochTime: Int
}
