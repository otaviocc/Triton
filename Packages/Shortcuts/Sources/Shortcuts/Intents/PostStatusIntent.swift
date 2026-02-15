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

import AppIntents
import Foundation

/// App Intent for composing and posting status updates to omg.lol.
///
/// This intent allows users to trigger status composition from Spotlight, Siri, or Shortcuts.
/// Users can optionally provide a message and emoji that will pre-populate the compose window.
///
/// ## Intent Parameters
///
/// - **message**: Optional text to pre-fill in the status compose field
/// - **emoji**: Optional emoji to use for the status (defaults to 💬)
///
/// ## System Integration
///
/// When triggered, this intent:
/// 1. Opens the OMG application (via `openAppWhenRun`)
/// 2. Posts a notification to open the compose window
/// 3. Passes message and emoji parameters via notification userInfo
/// 4. Returns immediately after posting the notification
///
/// The `ShortcutsService` observes the notification and opens the compose window with the
/// provided parameters.
struct PostStatusIntent: AppIntent {

    // MARK: - Properties

    static let openAppWhenRun = true
    static let title: LocalizedStringResource = "Post Status"
    static let description = IntentDescription(
        "Compose a new status post to omg.lol",
        categoryName: "Content Creation"
    )

    @Parameter(
        title: "Message",
        description: "The status message to post",
        default: ""
    )
    var message: String?

    @Parameter(
        title: "Emoji",
        description: "Emoji to use for the status",
        default: "💬"
    )
    var emoji: String?

    private let notificationCenter: NotificationCenterProtocol

    // MARK: - Lifecycle

    init(
        message: String?,
        emoji: String?,
        notificationCenter: NotificationCenterProtocol
    ) {
        self.notificationCenter = notificationCenter
        self.message = message
        self.emoji = emoji
    }

    init() {
        self.init(
            message: nil,
            emoji: nil,
            notificationCenter: NotificationCenter.default
        )
    }

    // MARK: - Public

    @MainActor
    func perform() async throws -> some IntentResult {
        var userInfo: [String: Any] = [:]

        if let message, !message.isEmpty {
            userInfo[Notification.IntentKeys.message] = message
        }
        if let emoji, !emoji.isEmpty {
            userInfo[Notification.IntentKeys.emoji] = emoji
        }

        notificationCenter
            .post(
                name: .openComposeWindow,
                object: nil,
                userInfo: userInfo.isEmpty ? nil : userInfo
            )

        return .result()
    }
}
