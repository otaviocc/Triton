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

/// Window configuration for editing an existing paste.
///
/// `EditPasteWindow` defines the window identifier and display name
/// for the paste editing interface.
public enum EditPasteWindow {

    public static let name = "Paste Editor"
    public static let id = "edit-paste-window"
}

/// Parameters for opening a paste editor window.
///
/// `EditPaste` contains all the information needed to populate the paste editor
/// with existing paste content for modification.
public struct EditPaste: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the paste is hosted.
    public let address: String

    /// The title of the paste.
    public let title: String

    /// The main content/body of the paste.
    public let content: String

    /// Whether the paste should be publicly listed or unlisted.
    public let isListed: Bool

    // MARK: - Lifecycle

    public init(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) {
        self.address = address
        self.title = title
        self.content = content
        self.isListed = isListed
    }
}
