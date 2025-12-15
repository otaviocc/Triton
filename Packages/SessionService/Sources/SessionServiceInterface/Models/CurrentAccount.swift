import Foundation

/// Represents complete account information for the currently authenticated user.
///
/// The `CurrentAccount` struct contains all user account details including personal
/// information and associated addresses. This model serves as the canonical
/// representation of user data within the session management system.
///
/// Unlike other account models that may be used for network transport or temporary
/// storage, `CurrentAccount` is specifically designed for session state management
/// and long-term persistence. It includes all the information needed to display
/// user profiles and manage address-related operations.
///
/// ## Usage Example
/// ```swift
/// let account = CurrentAccount(
///     name: "Alice Smith",
///     email: "alice@example.com",
///     creation: Date(),
///     addresses: [
///         // Regular address with expiration
///         CurrentAccount.Address(
///             address: "alice",
///             creation: Date(),
///             expire: futureDate
///         ),
///         // Lifetime address with no expiration
///         CurrentAccount.Address(
///             address: "lifetime-alice",
///             creation: Date(),
///             expire: nil
///         )
///     ]
/// )
/// ```
///
/// ## Data Management
/// - **Persistence**: Codable for storage across app launches
/// - **Comparison**: Equatable for state change detection
/// - **Concurrency**: Sendable for safe multi-threaded access
/// - **Validation**: Custom equality implementation ensures accurate change detection
///
/// ## Integration
/// This model integrates with the broader session management system, being used
/// by session services, account update repositories, and UI components throughout
/// the application.
public struct CurrentAccount: Codable, Equatable, Sendable {

    // MARK: - Properties

    /// The user's display name as registered with their account.
    ///
    /// This name represents how the user identifies themselves within the service
    /// and appears in various UI elements throughout the application.
    public let name: String

    /// The user's primary email address.
    ///
    /// This email serves as the primary identifier for the account and is used
    /// for communication, account recovery, and authentication purposes.
    public let email: String

    /// The timestamp when the user's account was originally created.
    ///
    /// This date provides historical context about the account age and can be
    /// used for analytics, user journey tracking, or feature eligibility.
    public let creation: Date

    /// All addresses associated with this account.
    ///
    /// This array contains all addresses (usernames) that the user owns or has
    /// registered through the service, including both active and expired addresses.
    /// Users can select from these addresses for various operations.
    public let addresses: [Address]

    // MARK: - Lifecycle

    /// Creates a new CurrentAccount with the specified information.
    ///
    /// This initializer constructs a complete account representation with all
    /// necessary user information and associated addresses. It's typically used
    /// when converting from network models or creating account data for testing.
    ///
    /// - Parameters:
    ///   - name: The user's display name
    ///   - email: The user's primary email address
    ///   - creation: The account creation timestamp
    ///   - addresses: Array of all addresses associated with the account
    public init(
        name: String,
        email: String,
        creation: Date,
        addresses: [Address]
    ) {
        self.name = name
        self.email = email
        self.creation = creation
        self.addresses = addresses
    }

    /// Compares two CurrentAccount instances for equality.
    ///
    /// This custom equality implementation ensures accurate comparison of all
    /// account properties, which is essential for detecting state changes in
    /// the session management system. The comparison includes all user data
    /// and associated addresses.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side account to compare
    ///   - rhs: The right-hand side account to compare
    /// - Returns: `true` if all properties are equal, `false` otherwise
    public static func == (
        lhs: CurrentAccount,
        rhs: CurrentAccount
    ) -> Bool {
        lhs.name == rhs.name &&
            lhs.email == rhs.email &&
            lhs.creation == rhs.creation &&
            lhs.addresses == rhs.addresses
    }
}

public extension CurrentAccount {

    // MARK: - Nested types

    /// Represents an address associated with the user's account.
    ///
    /// The `Address` struct contains information about a specific address (username)
    /// that the user has registered, including registration and expiration details.
    /// This model is used to track address ownership and manage renewal workflows.
    ///
    /// Each address represents a username that the user can select for various
    /// operations within the application, such as status updates or content management.
    ///
    /// ## Usage Example
    /// ```swift
    /// // Regular address with expiration
    /// let regularAddress = CurrentAccount.Address(
    ///     address: "alice",
    ///     creation: registrationDate,
    ///     expire: expirationDate
    /// )
    ///
    /// // Lifetime address with no expiration
    /// let lifetimeAddress = CurrentAccount.Address(
    ///     address: "lifetime-alice",
    ///     creation: registrationDate,
    ///     expire: nil
    /// )
    ///
    /// // Check if address is still active (lifetime addresses are always active)
    /// let isActive = regularAddress.expire?.compare(Date()) == .orderedDescending || regularAddress.expire == nil
    /// ```
    ///
    /// ## Lifecycle Management
    /// The address lifecycle includes registration, active use, and potential
    /// expiration. The application uses the expiration date to manage renewals
    /// and notify users of upcoming expirations.
    struct Address: Codable, Equatable, Sendable {

        // MARK: - Properties

        /// The address string (username).
        ///
        /// This represents the actual username that the user can use for
        /// communication, web presence, or other services provided by the platform.
        public let address: String

        /// The date when this address was originally registered.
        ///
        /// This timestamp provides historical information about when the user
        /// first acquired this address, useful for account history and analytics.
        public let creation: Date

        /// The date when this address registration expires, if it has an expiration date.
        ///
        /// This optional timestamp is essential for renewal management, allowing the
        /// application to display warnings, send notifications, or restrict
        /// features as the expiration date approaches. A `nil` value indicates a
        /// lifetime address that never expires and does not require renewal.
        ///
        /// - Note: Lifetime addresses return `nil` and remain active indefinitely.
        public let expire: Date?

        // MARK: - Lifecycle

        /// Creates a new Address with the specified information.
        ///
        /// This initializer constructs an address record with all necessary
        /// registration and expiration details. It's typically used when
        /// converting from network response models or creating test data.
        ///
        /// - Parameters:
        ///   - address: The address string (username)
        ///   - creation: The registration date
        ///   - expire: The expiration date
        public init(
            address: String,
            creation: Date,
            expire: Date?
        ) {
            self.address = address
            self.creation = creation
            self.expire = expire
        }

        /// Compares two Address instances for equality.
        ///
        /// This custom equality implementation ensures accurate comparison of all
        /// address properties, which is important for detecting changes in the
        /// user's address list and managing UI updates accordingly.
        ///
        /// - Parameters:
        ///   - lhs: The left-hand side address to compare
        ///   - rhs: The right-hand side address to compare
        /// - Returns: `true` if all properties are equal, `false` otherwise
        public static func == (
            lhs: Address,
            rhs: Address
        ) -> Bool {
            lhs.address == rhs.address &&
                lhs.creation == rhs.creation &&
                lhs.expire == rhs.expire
        }
    }
}
