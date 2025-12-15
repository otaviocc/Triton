/// A protocol for managing user session state and account information.
///
/// The `SessionServiceProtocol` serves as the central interface for session management
/// within the application. It maintains the current user's account information and
/// selected address, providing both synchronous access to current values and reactive
/// streams for observing changes over time.
///
/// This protocol abstracts the session management layer, allowing different implementations
/// to handle persistence, caching, and state synchronization while providing a consistent
/// interface to the rest of the application. The service is thread-safe (Sendable) and
/// designed to work seamlessly with Swift's async/await concurrency model.
///
/// ## Usage Example
/// ```swift
/// class ViewModel: ObservableObject {
///     private let sessionService: SessionServiceProtocol
///     private var observationTask: Task<Void, Never>?
///
///     init(sessionService: SessionServiceProtocol) {
///         self.sessionService = sessionService
///
///         // Observe account changes
///         observationTask = Task {
///             for await account in sessionService.observeAccount() {
///                 // Handle account updates
///             }
///         }
///     }
///
///     deinit {
///         observationTask?.cancel()
///     }
/// }
/// ```
///
/// ## State Management
/// The session service manages three primary pieces of state:
/// - **Account**: Current user account information (name, email, addresses)
/// - **Selected Address**: The currently active address from the user's available addresses
/// - **Session**: Combined session information including both account and selected address
///
/// ## Threading
/// All operations are safe to call from any thread, with the service handling
/// thread coordination internally. Observation streams emit values sequentially
/// to support UI updates.
public protocol SessionServiceProtocol: Sendable {

    /// The current account information for the logged-in user.
    ///
    /// This property provides immediate access to the current account state,
    /// which can be either `.notSynchronized` if no account data is available,
    /// or `.account(current:)` containing the user's account information.
    ///
    /// Use this property when you need the current account state synchronously,
    /// or use `observeAccount()` to observe changes over time.
    var account: Account { get async }

    /// The currently selected address for the user.
    ///
    /// This property provides immediate access to the selected address state,
    /// which can be either `.notSet` if no address is selected, or `.address(current:)`
    /// containing the selected address string.
    ///
    /// The selected address represents the active address that the user is currently
    /// using for operations like posting status updates or managing content.
    var address: Address { get async }

    /// Observes account state changes whenever the account information is updated.
    ///
    /// This method returns an `AsyncStream` that emits the current `Account` value
    /// whenever there are changes to the user's account information, including when
    /// account data is first loaded, updated from the server, or cleared during logout.
    ///
    /// The stream immediately emits the current account value upon subscription,
    /// then continues to emit updates as they occur. The stream never throws errors.
    ///
    /// Use this to keep your UI synchronized with account state changes.
    ///
    /// - Returns: An async stream that emits `Account` values whenever the account state changes
    func observeAccount() -> AsyncStream<Account>

    /// Observes selected address changes whenever the user selects a different address.
    ///
    /// This method returns an `AsyncStream` that emits the current `Address` value
    /// whenever the user changes their selected address, including when an address
    /// is first selected or when the selection is cleared.
    ///
    /// The stream immediately emits the current address value upon subscription,
    /// then continues to emit updates as they occur. The stream never throws errors.
    ///
    /// Use this to update address-dependent UI components and workflows.
    ///
    /// - Returns: An async stream that emits `Address` values whenever the selected address changes
    func observeAddress() -> AsyncStream<Address>

    /// Observes complete session information whenever any session component changes.
    ///
    /// This method returns an `AsyncStream` that emits the current `Session` value
    /// whenever there are changes to either the account information or selected address.
    /// It provides a unified way to observe all session-related changes in a single stream.
    ///
    /// The stream immediately emits the current session value upon subscription,
    /// then continues to emit updates as they occur. The session can be either
    /// `.notAvailable` when no session data is present, or `.session(account:selectedAddress:)`
    /// containing the complete session state.
    ///
    /// - Returns: An async stream that emits `Session` values whenever any session component changes
    func observeSession() -> AsyncStream<Session>

    /// Updates the current account information and notifies all observers.
    ///
    /// This method stores the provided account information as the current session's
    /// account data and broadcasts the update to all active observers via the
    /// account and session observation streams. The account information includes
    /// user details and all associated addresses.
    ///
    /// Calling this method will cause `observeAccount()` and `observeSession()`
    /// streams to emit updated values to all their subscribers.
    ///
    /// - Parameter currentAccount: The account information to store as the current account
    func setCurrentAccount(_ currentAccount: CurrentAccount) async

    /// Updates the selected address and notifies all observers.
    ///
    /// This method stores the provided address as the currently selected address
    /// and broadcasts the update to all active observers via the address and
    /// session observation streams. The selected address represents the active
    /// address for user operations.
    ///
    /// Calling this method will cause `observeAddress()` and `observeSession()`
    /// streams to emit updated values to all their subscribers.
    ///
    /// - Parameter address: The address string to set as the currently selected address
    func setSelectedAddress(_ address: SelectedAddress) async

    /// Clears all session information and resets to initial state.
    ///
    /// This method removes all stored session data including account information
    /// and selected address, returning the service to its initial state. It's
    /// typically called during logout operations.
    ///
    /// After calling this method:
    /// - `account` will return `.notSynchronized`
    /// - `address` will return `.notSet`
    /// - All observation streams will emit their respective "empty" states
    ///
    /// This triggers broadcasts on all observation streams to notify observers
    /// of the session clear.
    func clearSession() async
}
