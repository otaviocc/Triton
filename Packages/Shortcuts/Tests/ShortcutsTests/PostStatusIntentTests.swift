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
