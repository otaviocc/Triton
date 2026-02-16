// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/// Represents the complete session state combining account and address information.
///
/// The `Session` enum encapsulates the overall session state of a user, providing
/// a unified view of both account information and the currently selected address.
/// This model serves as the primary state representation for session-dependent
/// UI components and business logic.
///
/// The enum uses associated values to provide type-safe access to session data,
/// ensuring that session information can only be accessed when it's actually available.
/// This prevents common bugs related to accessing session data when no user is logged in.
///
/// ## Usage Example
/// ```swift
/// switch session {
/// case .notAvailable:
///     // Show login screen
///     LoginView()
/// case .session(let account, let selectedAddress):
///     // Show main app with user data
///     MainView(account: account, selectedAddress: selectedAddress)
/// }
/// ```
///
/// ## State Transitions
/// The session typically transitions through these states:
/// 1. `.notAvailable` - Initial state or after logout
/// 2. `.session(account:selectedAddress:)` - After successful login and address selection
///
/// ## Thread Safety
/// This enum is `Sendable`, making it safe to pass between different actors and
/// concurrent contexts, which is essential for session state management across
/// the application's reactive architecture.
public enum Session: Equatable, Sendable {

    /// Indicates that no session information is currently available.
    ///
    /// This case represents the state when no user is logged in, when session
    /// data is being loaded, or after the session has been cleared during logout.
    /// UI components should show appropriate login or loading states when this
    /// case is encountered.
    case notAvailable

    /// Contains complete session information for an active user session.
    ///
    /// This case holds both the user's account information and their currently
    /// selected address, providing all the data needed for session-dependent
    /// operations and UI display.
    ///
    /// - Parameters:
    ///   - account: The complete account information including user details and available addresses
    ///   - selectedAddress: The address currently selected by the user for active operations
    case session(
        account: CurrentAccount,
        selectedAddress: SelectedAddress
    )
}
