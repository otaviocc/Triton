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
import PURLsPersistenceService
import SwiftData
import SwiftUI

struct PURLsListView: View {

    // MARK: - Properties

    @State private var viewModel: PURLsListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var purls: [PURL]

    // MARK: - Lifecycle

    init(
        viewModel: PURLsListViewModel
    ) {
        self.viewModel = viewModel

        _purls = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if purls.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.purls)
            } else {
                makeListView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchPURLs()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(purls, id: \.id) { purl in
                    PURLContainer(purl: purl)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct PURLContainer: View {

    // MARK: - Properties

    let purl: PURL
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makePURLViewModel(
            purl: purl
        )

        PURLView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = PURLsRepositoryMother.makePURLsRepository()
        let environment = PURLsEnvironmentMother.makePURLsEnvironment()

        PURLsListView(
            viewModel: PURLsListViewModelMother.makePURLsListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.purlsContainer.mainContext)
        .frame(width: 420)
    }

    #Preview("With Content") {
        let repository = PURLsRepositoryMother.makePURLsRepository(count: 0)
        let environment = PURLsEnvironmentMother.makePURLsEnvironment()

        PURLsListView(
            viewModel: PURLsListViewModelMother.makePURLsListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.purlsContainer.mainContext)
        .frame(width: 420)
    }

#endif
