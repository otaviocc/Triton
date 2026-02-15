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

/// Notification names for App Intents communication.
///
/// These notifications are posted by `IntentCoordinator` when App Intents
/// are triggered, and should be observed by `ShortcutsService`.
extension Notification.Name {

    /// Posted when the app should open the compose status window.
    static let openComposeWindow = Notification.Name("com.otaviocc.triton.openComposeWindow")

    /// Posted when the app should open the add PURL window.
    static let openAddPURLWindow = Notification.Name("com.otaviocc.triton.openAddPURLWindow")

    /// Posted when the app should open the upload picture window.
    static let openUploadPictureWindow = Notification.Name("com.otaviocc.triton.openUploadPictureWindow")

    /// Posted when the app should open the create paste window.
    static let openCreatePasteWindow = Notification.Name("com.otaviocc.triton.openCreatePasteWindow")
}

/// Notification user info keys for App Intents.
extension Notification {

    enum IntentKeys {

        /// Key for status message in notification user info.
        static let message = "message"

        /// Key for emoji in notification user info.
        static let emoji = "emoji"
    }
}
