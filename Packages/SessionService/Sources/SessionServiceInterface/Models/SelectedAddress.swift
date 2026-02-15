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

/// A type alias representing a user's selected address string.
///
/// `SelectedAddress` is a simple string type that represents the address
/// (username) that a user has currently selected from their available addresses.
/// This typealias provides semantic meaning and type safety when working with
/// selected address values throughout the session management system.
///
/// The selected address is used throughout the application to identify the
/// active context for user operations, such as status updates, content creation,
/// or address-specific settings. By using this typealias, the code becomes more
/// self-documenting and maintains consistency across the codebase.
///
/// ## Usage Example
/// ```swift
/// let selectedAddress: SelectedAddress = "alice"
/// sessionService.setSelectedAddress(selectedAddress)
/// ```
///
/// ## Integration
/// This type integrates with the broader session management system:
/// - Used by `SessionServiceProtocol` for address selection operations
/// - Stored in `Address` enum cases to represent the selected state
/// - Part of `Session` enum associated values for complete session state
/// - Persisted by archiver systems for maintaining selection across app launches
public typealias SelectedAddress = String
