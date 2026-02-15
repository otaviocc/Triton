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

/// Window configuration for editing a weblog entry.
///
/// `EditWeblogEntryWindow` defines the window identifier and display name
/// for the weblog entry editing interface.
public enum EditWeblogEntryWindow {

    public static let name = "Weblog Entry Editor"
    public static let id = "edit-weblog-entry-window"
}

/// Parameters for opening a weblog entry editor window.
///
/// `EditWeblogEntry` contains all the information needed to populate the weblog editor
/// with existing entry content for modification.
public struct EditWeblogEntry: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the weblog entry is hosted.
    public let address: String

    /// The content/body of the weblog entry.
    public let body: String

    /// The publication date of the weblog entry.
    public let date: Date

    /// The unique identifier for the weblog entry, if it already exists.
    public let entryID: String?

    /// The publication status of the weblog entry.
    public let status: String?

    /// An array of tags associated with the weblog entry.
    public let tags: [String]

    // MARK: - Lifecycle

    public init(
        address: String,
        body: String,
        date: Date,
        entryID: String?,
        status: String?,
        tags: [String]
    ) {
        self.address = address
        self.body = body
        self.date = date
        self.entryID = entryID
        self.status = status
        self.tags = tags
    }
}
