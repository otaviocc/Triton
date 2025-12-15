import SwiftUI

/// The main application entry point for OMG.
///
/// `TritonApp` configures and manages all scenes in the application, including:
/// - Main window with primary navigation
/// - Feature-specific composition scenes (Status, PURLs, Web Page, Now Page, Weblog, Pics, Pastebin)
/// - Application settings
///
/// All scenes share a single `TritonEnvironment` instance for dependency injection.
@main
struct TritonApp: App {

    // MARK: - Properties

    private let environment = TritonEnvironment()

    // MARK: - Public

    var body: some Scene {
        // Main scene

        TritonScene(
            environment: environment
        )

        // Feature scenes

        environment
            .statusAppFactory
            .makeScene()

        environment
            .purlsAppFactory
            .makeScene()

        environment
            .webpageAppFactory
            .makeScene()

        environment
            .nowAppFactory
            .makeScene()

        environment
            .weblogAppFactory
            .makeScene()

        environment
            .picsAppFactory
            .makeScene()

        environment
            .pastebinAppFactory
            .makeScene()

        // Settings

        #if os(macOS)
            Settings {
                SettingsView(
                    environment: environment
                )
            }
        #endif
    }
}
