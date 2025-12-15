import Foundation

/// Notification names for App Intents communication.
///
/// These notifications are posted by `IntentCoordinator` when App Intents
/// are triggered, and should be observed by `ShortcutsService`.
extension Notification.Name {

    /// Posted when the app should open the compose status window.
    static let openComposeWindow = Notification.Name("com.otaviocc.triton.openComposeWindow")

    /// Posted when the app should open the add PURL window.
    static let openAddPURLWindow = Notification.Name("com.otaviocc.triton.openAddPURLWindow")

    /// Posted when the app should open the upload picture window.
    static let openUploadPictureWindow = Notification.Name("com.otaviocc.triton.openUploadPictureWindow")

    /// Posted when the app should open the create paste window.
    static let openCreatePasteWindow = Notification.Name("com.otaviocc.triton.openCreatePasteWindow")
}

/// Notification user info keys for App Intents.
extension Notification {

    enum IntentKeys {

        /// Key for status message in notification user info.
        static let message = "message"

        /// Key for emoji in notification user info.
        static let emoji = "emoji"
    }
}
