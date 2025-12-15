import Foundation
import Testing
@testable import Shortcuts

@Suite("CreatePURLIntent Tests")
struct CreatePURLIntentTests {

    @Test("CreatePURLIntent posts correct notification")
    @MainActor
    func perform_withIntent_postsOpenAddPURLWindowNotification() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let intent = CreatePURLIntent(notificationCenter: notificationCenterMock)

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openAddPURLWindow,
            "It should post notification with openAddPURLWindow name"
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
