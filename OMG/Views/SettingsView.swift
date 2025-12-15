import DesignSystem
import Status
import SwiftUI

/// A SwiftUI view that displays the application settings interface.
///
/// This view provides a tabbed interface for managing various application settings
/// across different feature modules. It currently includes settings for the Statuslog
/// feature, with the capability to expand to additional feature settings tabs in the future.
///
/// The view uses the dependency injection container (`TritonEnvironment`) to access
/// feature-specific settings views through their respective app factories, maintaining
/// loose coupling between the main application and feature modules.
struct SettingsView: View {

    // MARK: - Properties

    private let environment: any TritonEnvironmentProtocol

    // MARK: - Lifecycle

    init(
        environment: any TritonEnvironmentProtocol
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some View {
        TabView {
            makeStatusSettingsView()
                .tabItem {
                    Label("Statuslog", systemImage: "message")
                }

            TipJarView()
                .tabItem {
                    Label("Tip Jar", systemImage: "cup.and.saucer.fill")
                }
        }
        .frame(width: 480)
    }

    // MARK: - Private

    @ViewBuilder
    private func makeStatusSettingsView() -> some View {
        environment
            .statusAppFactory
            .makeSettingsView()
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        environment: TritonEnvironment()
    )
}
