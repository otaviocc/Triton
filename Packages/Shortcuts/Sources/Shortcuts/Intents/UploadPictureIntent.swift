import AppIntents
import Foundation

/// App Intent for uploading pictures to some.pics.
///
/// This intent allows users to trigger picture upload from Spotlight, Siri, or Shortcuts.
/// When activated, it opens the OMG application and displays the picture upload interface
/// for the some.pics image hosting service.
///
/// ## System Integration
///
/// When triggered, this intent:
/// 1. Opens the OMG application (via `openAppWhenRun`)
/// 2. Posts a notification to open the picture upload window
/// 3. Returns immediately after posting the notification
///
/// The `ShortcutsService` observes the notification and opens the appropriate window.
struct UploadPictureIntent: AppIntent {

    // MARK: - Properties

    static let openAppWhenRun = true
    static let title: LocalizedStringResource = "Upload Picture"
    static let description = IntentDescription(
        "Upload a new picture to some.pics",
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
                name: .openUploadPictureWindow,
                object: nil,
                userInfo: nil
            )

        return .result()
    }
}
