import AccountUpdateService
import Route
import Shortcuts
import SwiftUI

/// The primary scene that provides the main application window.
///
/// This scene creates the main application window with a navigation split view containing
/// a sidebar for feature selection and a detail view for the selected feature content.
/// It manages the application's primary navigation and integrates account update services.
struct TritonScene: Scene {

    // MARK: - Properties

    @State private var selection: RouteFeature? = .statuslog
    @Environment(\.openWindow) private var openWindow

    private let environment: any TritonEnvironmentProtocol

    // MARK: - Lifecycle

    init(
        environment: any TritonEnvironmentProtocol
    ) {
        self.environment = environment
    }

    // MARK: - Public

    var body: some Scene {
        WindowGroup(
            MainWindow.name,
            id: MainWindow.id
        ) {
            NavigationSplitView(
                sidebar: { makeSidebarView() },
                detail: { makeDetailView() }
            )
            #if os(macOS)
            .navigationTitle("Triton")
            #endif
            .environment(makeAccountUpdateService())
            .handlesExternalEvents(
                preferring: Set(arrayLiteral: "viewer"),
                allowing: Set(arrayLiteral: "*")
            )
            .onAppear {
                environment
                    .shortcutsService
                    .setUpObservers(openWindow: openWindow)
            }
        }
        .commandsRemoved()
    }

    // MARK: - Private

    @ViewBuilder
    private func makeSidebarView() -> some View {
        environment.sidebarAppFactory
            .makeAppView(selection: $selection)
        #if os(macOS)
            .navigationSplitViewColumnWidth(
                min: 150,
                ideal: 150,
                max: 200
            )
        #endif
    }

    @ViewBuilder
    private func makeDetailView() -> some View {
        DetailView(
            environment: environment,
            selectedFeature: $selection
        )
        #if os(macOS)
        .frame(minWidth: 320, idealWidth: 480)
        #endif
    }

    private func makeAccountUpdateService() -> AccountUpdateService {
        environment.accountUpdateAppFactory
            .makeAccountUpdateService()
    }
}
