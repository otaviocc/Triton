import Foundation

/// Represents complete account information including user details and associated addresses.
///
/// This model serves as the central data structure for user account information within
/// the application's session state. It combines core user details (name, email, creation date)
/// with all associated addresses/domains that belong to the account.
///
/// The `Account` struct is designed to be immutable and thread-safe (Sendable), making it
/// suitable for use across different actors and concurrent operations. It's also Codable
/// to support serialization for network communication and potential caching scenarios.
///
/// ## Usage Example
/// ```swift
/// let account = Account(
///     name: "John Doe",
///     email: "john@example.com",
///     creation: Date(),
///     addresses: [
///         // Regular address with expiration
///         Account.Address(
///             address: "john",
///             creation: Date(),
///             expire: Calendar.current.date(byAdding: .year, value: 1, to: Date())!
///         ),
///         // Lifetime address with no expiration
///         Account.Address(
///             address: "lifetime-john",
///             creation: Date(),
///             expire: nil
///         )
///     ]
/// )
/// ```
///
/// ## Data Flow
/// Account data flows through the system as follows:
/// 1. Network layer fetches account and address data separately
/// 2. Repository combines the responses into this unified Account model
/// 3. Persistence service stores the account in the session state
/// 4. UI components access the account information through the session service
public struct Account: Codable, Sendable {

    // MARK: - Properties

    /// The user's display name as registered with their account.
    ///
    /// This is the name that appears in user interface elements and represents
    /// how the user identifies themselves within the service.
    public let name: String

    /// The user's primary email address associated with their account.
    ///
    /// This email serves as the primary identifier for the account and is used
    /// for communication, account recovery, and authentication purposes.
    public let email: String

    /// The date when the user's account was originally created.
    ///
    /// This timestamp provides historical information about the account age
    /// and can be used for analytics, user journey tracking, or feature eligibility.
    public let creation: Date

    /// An array of all addresses associated with this account.
    ///
    /// Each address represents a username that the user owns or has
    /// registered through the service. This includes both active and expired addresses,
    /// allowing the application to display complete ownership history and manage
    /// renewal notifications.
    public let addresses: [Address]

    // MARK: - Lifecycle

    /// Creates a new Account instance with the specified user information and addresses.
    ///
    /// This initializer is typically used by the repository layer when combining
    /// network responses into a unified account model, or by test code when creating
    /// mock account data.
    ///
    /// - Parameters:
    ///   - name: The user's display name
    ///   - email: The user's primary email address
    ///   - creation: The date when the account was originally created
    ///   - addresses: An array of addresses/domains associated with this account
    public init(
        name: String,
        email: String,
        creation: Date,
        addresses: [Account.Address]
    ) {
        self.name = name
        self.email = email
        self.creation = creation
        self.addresses = addresses
    }
}

public extension Account {

    // MARK: - Nested types

    /// Represents an address associated with a user account.
    ///
    /// An address in this context represents a username that the user has
    /// registered through the service (e.g., "alice"). Each address includes
    /// registration and expiration information, allowing the application to track ownership
    /// status and manage renewal workflows.
    ///
    /// The Address struct is designed to be immutable and thread-safe, making it suitable
    /// for use in concurrent operations and actor-based architectures. It's also Codable
    /// to support serialization alongside its parent Account model.
    ///
    /// ## Usage Example
    /// ```swift
    /// // Regular address with expiration
    /// let regularAddress = Account.Address(
    ///     address: "alice",
    ///     creation: Date(),
    ///     expire: Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    /// )
    ///
    /// // Lifetime address with no expiration
    /// let lifetimeAddress = Account.Address(
    ///     address: "lifetime-alice",
    ///     creation: Date(),
    ///     expire: nil
    /// )
    ///
    /// // Check if address is still valid (lifetime addresses are always valid)
    /// let isActive = regularAddress.expire?.compare(Date()) == .orderedDescending || regularAddress.expire == nil
    /// ```
    ///
    /// ## Address Lifecycle
    /// 1. Address is registered by the user through the service
    /// 2. Registration information is fetched from the API
    /// 3. Address data is stored as part of the user's account
    /// 4. Application can display ownership status and renewal reminders based on expiration
    struct Address: Codable, Sendable {

        // MARK: - Properties

        /// The actual address string (e.g., "alice").
        ///
        /// This represents the username that the user can use for communication,
        /// web presence, or other services provided by the platform.
        public let address: String

        /// The date when this address was originally registered.
        ///
        /// This timestamp provides historical information about when the user
        /// first acquired this address, useful for account history and analytics.
        public let creation: Date

        /// The date when this address registration expires, if it has an expiration date.
        ///
        /// This optional timestamp is crucial for renewal management, allowing the application
        /// to display warnings, send notifications, or restrict features as the
        /// expiration date approaches. A `nil` value indicates a lifetime address that never
        /// expires and does not require renewal. Regular addresses past their expiration
        /// date may become unavailable for use.
        ///
        /// - Note: Lifetime addresses return `nil` and remain active indefinitely.
        public let expire: Date?

        // MARK: - Lifecycle

        /// Creates a new Address instance with the specified address information.
        ///
        /// This initializer is typically used by the repository layer when mapping
        /// network response data into domain models, or by test code when creating
        /// mock address data.
        ///
        /// - Parameters:
        ///   - address: The address string (e.g., "alice")
        ///   - creation: The date when this address was registered
        ///   - expire: The date when this address registration expires
        public init(
            address: String,
            creation: Date,
            expire: Date?
        ) {
            self.address = address
            self.creation = creation
            self.expire = expire
        }
    }
}
