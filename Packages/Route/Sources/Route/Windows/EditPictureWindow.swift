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

/// Window configuration for editing picture metadata.
///
/// `EditPictureWindow` defines the window identifier and display name
/// for the picture editing interface.
public enum EditPictureWindow {

    public static let name = "Picture Editor"
    public static let id = "edit-picture-window"
}

/// Parameters for opening a picture editor window.
///
/// `EditPicture` contains all the information needed to populate the picture editor
/// with existing metadata for modification.
public struct EditPicture: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the picture is hosted.
    public let address: String

    /// The unique identifier of the picture being edited.
    public let pictureID: String

    /// An optional caption describing the picture.
    public let caption: String?

    /// Optional alternative text for accessibility.
    public let altText: String?

    /// Optional array of tags for categorizing the picture.
    public let tags: [String]?

    // MARK: - Lifecycle

    public init(
        address: String,
        pictureID: String,
        caption: String?,
        altText: String?,
        tags: [String]?
    ) {
        self.address = address
        self.pictureID = pictureID
        self.caption = caption
        self.altText = altText
        self.tags = tags
    }
}
