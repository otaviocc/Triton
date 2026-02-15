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

/// App Intent for creating pastes on omg.lol pastebin.
///
/// This intent allows users to trigger paste creation from Spotlight, Siri, or Shortcuts.
/// When activated, it opens the OMG application and displays the paste creation interface
/// for the omg.lol pastebin service.
///
/// ## System Integration
///
/// When triggered, this intent:
/// 1. Opens the OMG application (via `openAppWhenRun`)
/// 2. Posts a notification to open the paste creation window
/// 3. Returns immediately after posting the notification
///
/// The `ShortcutsService` observes the notification and opens the appropriate window.
struct CreatePasteIntent: AppIntent {

    // MARK: - Properties

    static let openAppWhenRun = true
    static let title: LocalizedStringResource = "Create Paste"
    static let description = IntentDescription(
        "Create a new paste on omg.lol pastebin",
        categoryName: "Content Creation"
    )

    private let notificationCenter: NotificationCenterProtocol

    // MARK: - Lifecycle

    init(
        notificationCenter: NotificationCenterProtocol
    ) {
        self.notificationCenter = notificationCenter
    }

    init() {
        self.init(notificationCenter: NotificationCenter.default)
    }

    // MARK: - Public

    @MainActor
    func perform() async throws -> some IntentResult {
        notificationCenter
            .post(
                name: .openCreatePasteWindow,
                object: nil,
                userInfo: nil
            )

        return .result()
    }
}
