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
import SwiftData
import SwiftUI
import WebpagePersistenceService

struct WebpageListView: View {

    // MARK: - Properties

    @State private var viewModel: WebpageListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var webpages: [Webpage]

    // MARK: - Lifecycle

    init(
        viewModel: WebpageListViewModel
    ) {
        self.viewModel = viewModel

        _webpages = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if webpages.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.webpage)
            } else {
                makeListView()
            }
        }
        .task {
            try? await viewModel.fetchWebpages()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(webpages, id: \.id) { webpage in
                    WebpageContainer(
                        webpage: webpage,
                        isCurrent: webpage == webpages.first
                    )
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct WebpageContainer: View {

    // MARK: - Properties

    let webpage: Webpage
    let isCurrent: Bool
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makeWebpageViewModel(
            webpage: webpage,
            isCurrent: isCurrent
        )

        WebpageView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = WebpageRepositoryMother.makeWebpageRepository()
        let environment = WebpageEnvironmentMother.makeWebpageEnvironment()

        WebpageListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.webpageContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = WebpageRepositoryMother.makeWebpageRepository(count: 0)
        let environment = WebpageEnvironmentMother.makeWebpageEnvironment()

        WebpageListView(
            viewModel: .init(
                address: "otaviocc",
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.webpageContainer.mainContext)
    }

#endif
