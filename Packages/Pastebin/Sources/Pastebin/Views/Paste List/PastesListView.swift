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
import PastebinPersistenceService
import SwiftData
import SwiftUI

struct PastesListView: View {

    // MARK: - Properties

    @State private var viewModel: PastesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var pastes: [Paste]

    // MARK: - Lifecycle

    init(
        viewModel: PastesListViewModel
    ) {
        self.viewModel = viewModel

        _pastes = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if pastes.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.pastebin)
            } else {
                makeListView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchPastes()
        }
    }

    // MARK: - Private

    private func makeListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(pastes, id: \.id) { paste in
                    PasteContainer(paste: paste)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct PasteContainer: View {

    // MARK: - Properties

    let paste: Paste
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makePasteViewModel(
            paste: paste
        )

        PasteView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content") {
        let repository = PastebinRepositoryMother.makePastebinRepository()
        let environment = PastebinEnvironmentMother.makePastebinEnvironment()

        PastesListView(
            viewModel: PastesListViewModelMother.makePastesListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.pastebinContainer)
        .frame(width: 420)
    }

    #Preview("Without Content") {
        let repository = PastebinRepositoryMother.makePastebinRepository(count: 0)
        let environment = PastebinEnvironmentMother.makePastebinEnvironment()

        PastesListView(
            viewModel: PastesListViewModelMother.makePastesListViewModel()
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.pastebinContainer)
        .frame(width: 420)
    }

#endif
