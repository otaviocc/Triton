/// Represents the synchronization state of user account information.
///
/// The `Account` enum tracks whether user account information is currently
/// available and synchronized with the server. It provides type-safe access
/// to account data, ensuring that account information can only be accessed
/// when it has been successfully loaded and synchronized.
///
/// This model is used throughout the session management system to represent
/// the current state of account data, allowing UI components and business
/// logic to respond appropriately to different synchronization states.
///
/// ## Usage Example
/// ```swift
/// switch account {
/// case .notSynchronized:
///     // Show loading indicator or prompt to sync
///     LoadingView(message: "Syncing account...")
/// case .account(let currentAccount):
///     // Display account information
///     AccountView(account: currentAccount)
/// }
/// ```
///
/// ## State Flow
/// The account typically progresses through these states:
/// 1. `.notSynchronized` - Initial state, during sync, or after clear
/// 2. `.account(current:)` - After successful data synchronization
///
/// ## Persistence
/// This enum is `Codable`, allowing account state to be persisted across
/// app launches, and `Sendable` for safe concurrent access across the
/// application's actor-based architecture.
public enum Account: Codable, Equatable, Sendable {

    /// Indicates that account information is not currently synchronized.
    ///
    /// This case represents the state when no account data is available,
    /// when data is being loaded from the server, or when synchronization
    /// has failed. UI components should handle this state by showing
    /// loading indicators or prompting for account synchronization.
    case notSynchronized

    /// Contains synchronized account information for the current user.
    ///
    /// This case holds the complete account information that has been
    /// successfully loaded and synchronized, including user details
    /// and all associated addresses.
    ///
    /// - Parameter current: The synchronized account information
    case account(current: CurrentAccount)
}
