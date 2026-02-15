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

    private func makeCurrentAccountView() -> some View {
        environment
            .accountAppFactory
            .makeAppView()
    }

    private func makeStatusView() -> some View {
        environment
            .statusAppFactory
            .makeAppView()
    }

    private func makeAuthView() -> some View {
        environment
            .authAppFactory
            .makeAppView()
    }

    private func makeNowView() -> some View {
        environment
            .nowAppFactory
            .makeAppView()
    }

    private func makePURLsView() -> some View {
        environment
            .purlsAppFactory
            .makeAppView()
    }

    private func makeWebpageView() -> some View {
        environment
            .webpageAppFactory
            .makeAppView()
    }

    private func makePastebinView() -> some View {
        environment
            .pastebinAppFactory
            .makeAppView()
    }

    private func makeWeblogAppView() -> some View {
        environment
            .weblogAppFactory
            .makeAppView()
    }

    private func makePicsAppView() -> some View {
        environment
            .picsAppFactory
            .makeAppView()
    }
}
