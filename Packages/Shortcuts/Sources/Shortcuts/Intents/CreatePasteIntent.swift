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
