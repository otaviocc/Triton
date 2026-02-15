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
import Testing
@testable import Shortcuts

@Suite("PostStatusIntent Tests")
struct PostStatusIntentTests {

    @Test("PostStatusIntent posts notification with no parameters uses default emoji")
    @MainActor
    func perform_withNoParameters_postsOpenComposeWindowNotificationWithDefaultEmoji() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let intent = PostStatusIntent(
            message: nil,
            emoji: nil,
            notificationCenter: notificationCenterMock
        )

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openComposeWindow,
            "It should post notification with openComposeWindow name"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.object == nil,
            "It should post notification with nil object"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.emoji] as? String == "💬",
            "It should include default emoji in userInfo"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.userInfo?[Notification.IntentKeys.message] == nil,
            "It should not include message in userInfo when not provided"
        )
    }

    @Test("PostStatusIntent posts notification with message parameter uses default emoji")
    @MainActor
    func perform_withMessage_postsOpenComposeWindowNotificationWithMessageAndDefaultEmoji() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let testMessage = "Test status message"
        let intent = PostStatusIntent(
            message: testMessage,
            emoji: nil,
            notificationCenter: notificationCenterMock
        )

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openComposeWindow,
            "It should post notification with openComposeWindow name"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.message] as? String == testMessage,
            "It should include message in userInfo"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.emoji] as? String == "💬",
            "It should include default emoji in userInfo"
        )
    }

    @Test("PostStatusIntent posts notification with emoji parameter")
    @MainActor
    func perform_withEmoji_postsOpenComposeWindowNotificationWithEmojiInUserInfo() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let testEmoji = "🎉"
        let intent = PostStatusIntent(
            message: nil,
            emoji: testEmoji,
            notificationCenter: notificationCenterMock
        )

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openComposeWindow,
            "It should post notification with openComposeWindow name"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.emoji] as? String == testEmoji,
            "It should include emoji in userInfo"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.userInfo?[Notification.IntentKeys.message] == nil,
            "It should not include message in userInfo when not provided"
        )
    }

    @Test("PostStatusIntent posts notification with both parameters")
    @MainActor
    func perform_withMessageAndEmoji_postsOpenComposeWindowNotificationWithBothInUserInfo() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let testMessage = "Test status message"
        let testEmoji = "🎉"
        let intent = PostStatusIntent(
            message: testMessage,
            emoji: testEmoji,
            notificationCenter: notificationCenterMock
        )

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openComposeWindow,
            "It should post notification with openComposeWindow name"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.message] as? String == testMessage,
            "It should include message in userInfo"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?
                .userInfo?[Notification.IntentKeys.emoji] as? String == testEmoji,
            "It should include emoji in userInfo"
        )
    }
}
