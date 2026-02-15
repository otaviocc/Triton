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

/// Window configuration for editing a webpage.
///
/// `EditWebpageWindow` defines the window identifier and display name
/// for the webpage editing interface.
public enum EditWebpageWindow {

    public static let name = "Webpage Editor"
    public static let id = "edit-webpage-window"
}

/// Parameters for opening a webpage editor window.
///
/// `EditWebpage` contains all the information needed to populate the webpage editor
/// with existing content for modification.
public struct EditWebpage: Codable, Hashable {

    // MARK: - Properties

    /// The user's OMG address where the webpage is hosted.
    public let address: String

    /// The HTML/content of the webpage.
    public let content: String

    // MARK: - Lifecycle

    public init(
        address: String,
        content: String
    ) {
        self.address = address
        self.content = content
    }
}
