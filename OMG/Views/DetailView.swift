import DesignSystem
import Route
import SwiftUI

/// A SwiftUI view that displays the detail content for the selected application feature.
///
/// This view acts as the main content router in the application, switching between
/// different feature views based on the currently selected navigation item. It coordinates
/// with the app's dependency injection container to instantiate the appropriate feature
/// view through their respective app factories.
///
/// The view handles routing for all major application features including Statuslog,
/// PURLs, Account, Auth, Now page, Webpage, Pastebin, Weblog, and some.pics.
struct DetailView: View {

    // MARK: - Properties

    private let environment: any TritonEnvironmentProtocol
    private var selectedFeature: Binding<RouteFeature?>

    // MARK: - Lifecycle

    init(
        environment: any TritonEnvironmentProtocol,
        selectedFeature: Binding<RouteFeature?>
    ) {
        self.environment = environment
        self.selectedFeature = selectedFeature
    }

    // MARK: - Public

    var body: some View {
        switch selectedFeature.wrappedValue {
        case .statuslog:
            makeStatusView()
        case .purls:
            makePURLsView()
        case .account:
            makeCurrentAccountView()
        case .auth:
            makeAuthView()
        case .nowPage:
            makeNowView()
        case .webpage:
            makeWebpageView()
        case .pastebin:
            makePastebinView()
        case .weblog:
            makeWeblogAppView()
        case .somePics:
            makePicsAppView()
        default:
            ContentUnavailableViewFactory.makeNotImplementedView()
        }
    }

    // MARK: - Private

    @ViewBuilder
    private func makeCurrentAccountView() -> some View {
        environment
            .accountAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makeStatusView() -> some View {
        environment
            .statusAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makeAuthView() -> some View {
        environment
            .authAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makeNowView() -> some View {
        environment
            .nowAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makePURLsView() -> some View {
        environment
            .purlsAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makeWebpageView() -> some View {
        environment
            .webpageAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makePastebinView() -> some View {
        environment
            .pastebinAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makeWeblogAppView() -> some View {
        environment
            .weblogAppFactory
            .makeAppView()
    }

    @ViewBuilder
    private func makePicsAppView() -> some View {
        environment
            .picsAppFactory
            .makeAppView()
    }
}
