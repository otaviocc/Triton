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

/// Window configuration for composing a new status update.
///
/// `ComposeWindow` defines the window identifier and display name
/// for the status composition interface.
public enum ComposeWindow {

    public static let name = "Status"
    public static let id = "compose-window"
}

/// Parameters for opening a status composition window.
///
/// `ComposeStatus` contains the information needed to pre-populate
/// the status composition form with initial content.
public struct ComposeStatus: Codable, Hashable {

    // MARK: - Properties

    /// The text content of the status update.
    public let message: String

    /// An optional emoji to accompany the status update.
    public let emoji: String?

    // MARK: - Lifecycle

    public init(
        message: String,
        emoji: String? = nil
    ) {
        self.message = message
        self.emoji = emoji
    }
}
