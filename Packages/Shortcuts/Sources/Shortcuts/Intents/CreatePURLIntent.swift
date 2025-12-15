import AppIntents
import Foundation

/// App Intent for creating permanent URLs (PURLs) on omg.lol.
///
/// This intent allows users to trigger PURL creation from Spotlight, Siri, or Shortcuts.
/// When activated, it opens the OMG application and displays the PURL creation interface.
///
/// ## System Integration
///
/// When triggered, this intent:
/// 1. Opens the OMG application (via `openAppWhenRun`)
/// 2. Posts a notification to open the PURL creation window
/// 3. Returns immediately after posting the notification
///
/// The `ShortcutsService` observes the notification and opens the appropriate window.
struct CreatePURLIntent: AppIntent {

    // MARK: - Properties

    static let openAppWhenRun = true
    static let title: LocalizedStringResource = "Create PURL"
    static let description = IntentDescription(
        "Create a new permanent URL on omg.lol",
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
                name: .openAddPURLWindow,
                object: nil,
                userInfo: nil
            )

        return .result()
    }
}
