import Foundation
import Testing
@testable import Shortcuts

@Suite("UploadPictureIntent Tests")
struct UploadPictureIntentTests {

    @Test("UploadPictureIntent posts correct notification")
    @MainActor
    func perform_withIntent_postsOpenUploadPictureWindowNotification() async throws {
        // Given
        let notificationCenterMock = NotificationCenterProtocolMock()
        let intent = UploadPictureIntent(notificationCenter: notificationCenterMock)

        // When
        _ = try await intent.perform()

        // Then
        #expect(
            notificationCenterMock.postedNotifications.count == 1,
            "It should post exactly one notification"
        )

        #expect(
            notificationCenterMock.postedNotifications.first?.name == .openUploadPictureWindow,
            "It should post notification with openUploadPictureWindow name"
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
