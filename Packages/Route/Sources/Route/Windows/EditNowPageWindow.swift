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

/// Window configuration for editing a user's now page.
///
/// `EditNowPageWindow` defines the window identifier and display name
/// for the now page editing interface.
public enum EditNowPageWindow {

    public static let name = "Now Page Editor"
    public static let id = "edit-now-window"
}

/// Parameters for opening a now page editor window.
///
/// `EditNowPage` contains all the information needed to populate the now page editor
/// with existing content for modification.
public struct EditNowPage: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the now page is hosted.
    public let address: String

    /// The main content/body of the now page.
    public let content: String

    /// Whether the now page should be publicly listed or unlisted.
    public let isListed: Bool

    // MARK: - Lifecycle

    public init(
        address: String,
        content: String,
        isListed: Bool
    ) {
        self.address = address
        self.content = content
        self.isListed = isListed
    }
}
