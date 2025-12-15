import Foundation
import Route
import SwiftUI

/// Service responsible for observing App Intent notifications and coordinating window actions.
///
/// This service bridges the gap between App Intents (which run in a separate process) and
/// the main application's UI layer. When App Intents are triggered from Spotlight, Siri, or
/// Shortcuts, they post notifications which this service observes and translates into
/// window opening actions.
///
/// ## Architecture
///
/// ```
/// User Trigger → App Intent → Notification → ShortcutsService → openWindow
/// (Spotlight)     (separate      (IPC)        (main app)      (SwiftUI)
///                  process)
/// ```
///
/// The service is thread-safe and conforms to `Sendable`.
public protocol ShortcutsServiceProtocol: Sendable {

    /// Sets up notification observers for all App Intent actions.
    ///
    /// This method registers observers for notifications posted by App Intents and translates
    /// them into window opening actions using the provided `OpenWindowAction`. Each observer
    /// executes on the main queue and uses `MainActor.assumeIsolated` to safely call the
    /// main actor-isolated `openWindow` function.
    ///
    /// ## Observed Intents
    ///
    /// - **Post Status**: Opens compose window with optional message and emoji
    /// - **Create PURL**: Opens PURL creation window
    /// - **Upload Picture**: Opens picture upload window
    /// - **Create Paste**: Opens paste creation window
    ///
    /// - Parameter openWindow: SwiftUI's OpenWindowAction for creating new windows
    ///
    /// - Note: This method should be called once when the main scene appears. Multiple calls
    ///         will register duplicate observers.
    @MainActor
    func setUpObservers(openWindow: OpenWindowAction)
}

final class ShortcutsService: ShortcutsServiceProtocol {

    // MARK: - Properties

    private let notificationCenter: NotificationCenterProtocol

    // MARK: - Lifecycle

    init(
        notificationCenter: NotificationCenterProtocol
    ) {
        self.notificationCenter = notificationCenter
    }

    // MARK: - Public

    @MainActor
    func setUpObservers(openWindow: OpenWindowAction) {
        notificationCenter
            .addObserver(
                forName: .openComposeWindow,
                object: nil,
                queue: .main
            ) { notification in
                let message = notification.userInfo?[Notification.IntentKeys.message] as? String ?? ""
                let emoji = notification.userInfo?[Notification.IntentKeys.emoji] as? String ?? "💬"

                MainActor.assumeIsolated {
                    openWindow(
                        id: ComposeWindow.id,
                        value: ComposeStatus(message: message, emoji: emoji)
                    )
                }
            }

        notificationCenter
            .addObserver(
                forName: .openAddPURLWindow,
                object: nil,
                queue: .main
            ) { _ in
                MainActor.assumeIsolated {
                    openWindow(id: AddPURLWindow.id)
                }
            }

        notificationCenter
            .addObserver(
                forName: .openUploadPictureWindow,
                object: nil,
                queue: .main
            ) { _ in
                MainActor.assumeIsolated {
                    openWindow(id: UploadPictureWindow.id)
                }
            }

        notificationCenter
            .addObserver(
                forName: .openCreatePasteWindow,
                object: nil,
                queue: .main
            ) { _ in
                MainActor.assumeIsolated {
                    openWindow(id: CreatePasteWindow.id)
                }
            }
    }
}
