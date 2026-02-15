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

import AppIntents

/// Provides App Shortcuts for the OMG app that appear in Spotlight, Siri, and Shortcuts.
///
/// This provider is automatically discovered by the operating system through Swift metadata
/// reflection at compile time. When the app is built, the App Intents framework scans the
/// binary for all types conforming to `AppShortcutsProvider` and extracts their shortcuts.
///
/// ## Operating System Discovery
///
/// The discovery process works as follows:
/// 1. **Build Time**: The compiler embeds metadata about `AppShortcutsProvider` conformances
/// 2. **App Launch**: The system indexes the app's shortcuts on first launch or update
/// 3. **Spotlight Integration**: Phrases are registered with Spotlight's search index
/// 4. **User Search**: When users type matching phrases, Spotlight surfaces these shortcuts
///
/// ## Phrase Requirements
///
/// Each phrase must include `\(.applicationName)` to help the system disambiguate when
/// multiple apps offer similar shortcuts. For example, "Post status in Triton" ensures
/// the system knows this action belongs to this specific app.
///
/// ## System Integration Points
///
/// - **Spotlight**: Users can trigger shortcuts by typing phrases like "Post status in Triton"
/// - **Siri**: Voice commands work automatically (e.g., "Hey Siri, post status in Triton")
/// - **Shortcuts App**: Shortcuts appear as suggested actions for automation workflows
///
/// - Note: This provider is instantiated by the system, not by application code.
struct ShortcutsProvider: AppShortcutsProvider {

    /// Defines the available app shortcuts with their associated phrases and intents.
    ///
    /// Each `AppShortcut` maps one or more natural language phrases to a specific intent.
    /// When a user triggers a phrase through Spotlight, Siri, or Shortcuts, the system
    /// instantiates and executes the corresponding intent.
    ///
    /// ## Shortcut Structure
    ///
    /// Each shortcut includes:
    /// - **intent**: The `AppIntent` to execute when triggered
    /// - **phrases**: Natural language patterns that match this action
    /// - **shortTitle**: Brief display name for the Shortcuts app
    /// - **systemImageName**: SF Symbol for visual representation
    ///
    /// ## Available Shortcuts
    ///
    /// - **Post Status**: Opens compose window for status updates
    /// - **Create PURL**: Opens window to create permanent URLs
    /// - **Upload Picture**: Opens picture upload interface
    /// - **Create Paste**: Opens paste creation interface
    ///
    /// - Important: Phrases must include `\(.applicationName)` per Apple's requirements.
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: PostStatusIntent(),
            phrases: [
                "Post status in \(.applicationName)",
                "Compose status in \(.applicationName)",
                "New status in \(.applicationName)"
            ],
            shortTitle: "Post Status",
            systemImageName: "square.and.pencil"
        )

        AppShortcut(
            intent: CreatePURLIntent(),
            phrases: [
                "Create PURL in \(.applicationName)",
                "Add PURL in \(.applicationName)",
                "New PURL in \(.applicationName)"
            ],
            shortTitle: "Create PURL",
            systemImageName: "link"
        )

        AppShortcut(
            intent: UploadPictureIntent(),
            phrases: [
                "Upload picture in \(.applicationName)",
                "Upload photo in \(.applicationName)",
                "Upload image in \(.applicationName)"
            ],
            shortTitle: "Upload Picture",
            systemImageName: "photo.badge.plus"
        )

        AppShortcut(
            intent: CreatePasteIntent(),
            phrases: [
                "Create paste in \(.applicationName)",
                "New paste in \(.applicationName)",
                "Add paste in \(.applicationName)"
            ],
            shortTitle: "Create Paste",
            systemImageName: "doc.text"
        )
    }
}
