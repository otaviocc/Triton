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

import Foundation

/// A protocol for managing authentication session state and secure token storage.
///
/// This protocol defines the interface for handling user authentication sessions,
/// including secure access token management and reactive authentication state monitoring.
/// It provides a centralized way to manage authentication state across the application
/// with secure Keychain storage and reactive streams for state changes.
///
/// The service handles the complete authentication lifecycle, from initial login through
/// logout, with automatic cleanup of sensitive data and notification of authentication
/// state changes to dependent components.
///
/// All operations are async-safe and designed to work seamlessly with SwiftUI and
/// other reactive components that need to respond to authentication state changes.
public protocol AuthSessionServiceProtocol: Sendable {

    /// The current access token used for authenticated network requests.
    ///
    /// This token is securely stored in the device's Keychain and is used to authenticate
    /// API requests. The token is automatically loaded from secure storage on app startup
    /// and persisted across app launches. Returns `nil` when the user is not authenticated.
    ///
    /// The token should be included in network request headers for authenticated endpoints.
    var accessToken: String? { get async }

    /// The current authentication state of the user.
    ///
    /// This computed property returns `true` when a valid access token is available,
    /// indicating the user is authenticated and can make authenticated requests.
    /// Returns `false` when no token is available or the user has logged out.
    ///
    /// This property is reactive and its changes trigger updates to observers
    /// via the `observeLoginState()` stream.
    var isLoggedIn: Bool { get async }

    /// Updates the access token and authentication state.
    ///
    /// This method securely stores the provided token in the Keychain and updates
    /// the authentication state accordingly. When a token is provided, the user
    /// becomes authenticated. When `nil` is provided, the user is logged out and
    /// the token is removed from secure storage.
    ///
    /// Setting the token automatically triggers notifications to observers:
    /// - Login state observers receive the new authentication state
    /// - Logout event observers are notified when transitioning from authenticated to unauthenticated
    ///
    /// - Parameter token: The access token to store, or `nil` to log out and clear the token.
    func setAccessToken(_ token: String?) async

    /// Provides a stream of authentication state changes.
    ///
    /// This method returns an AsyncStream that emits the current authentication state
    /// immediately upon subscription, followed by updates whenever the authentication
    /// state changes (login or logout events).
    ///
    /// The stream is useful for reactive UI components that need to update based on
    /// authentication state, such as showing/hiding login screens or authenticated content.
    ///
    /// - Returns: An `AsyncStream<Bool>` that emits `true` for authenticated state and `false` for unauthenticated
    /// state.
    func observeLoginState() -> AsyncStream<Bool>

    /// Provides a stream of logout events.
    ///
    /// This method returns an AsyncStream that emits events specifically when the user
    /// logs out (transitions from authenticated to unauthenticated state). This is useful
    /// for components that need to perform cleanup or reset operations when the user logs out,
    /// such as clearing cached data, resetting UI state, or clearing local databases.
    ///
    /// The stream only emits when transitioning from having a token to not having a token.
    /// It does not emit during initial app startup if the user is already logged out.
    ///
    /// - Returns: An `AsyncStream<Void>` that emits events when the user logs out.
    func observeLogoutEvents() -> AsyncStream<Void>
}
