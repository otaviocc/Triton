import Foundation
import Testing
@testable import Shortcuts

@Suite("CreatePasteIntent Tests")
struct CreatePasteIntentTests {

    @Test("CreatePasteIntent posts correct notification")
    @MainActor
    func perform_withIntent_postsOpenCreatePasteWindowNotification() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let intent = CreatePasteIntent(notificationCenter: notificationCenterMock)

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openCreatePasteWindow,
            "It should post notification with openCreatePasteWindow name"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.object == nil,
            "It should post notification with nil object"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.userInfo == nil,
            "It should post notification with nil userInfo"
        )
    }
}
