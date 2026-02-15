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
import WeblogPersistenceService

struct WeblogEntriesListView: View {

    // MARK: - Properties

    @State private var viewModel: WeblogEntriesListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var entries: [WeblogEntry]

    // MARK: - Lifecycle

    init(
        viewModel: WeblogEntriesListViewModel
    ) {
        self.viewModel = viewModel

        _entries = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Public

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableViewFactory.makeEmptyFeature(.weblog)
            } else {
                makeEntriesView()
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            try? await viewModel.fetchWeblogEntries()
        }
    }

    // MARK: - Private

    private func makeEntriesView() -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(entries, id: \.id) { entry in
                    WeblogEntryContainer(entry: entry)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct WeblogEntryContainer: View {

    // MARK: - Properties

    let entry: WeblogEntry
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makeWeblogEntryViewModel(
            entry: entry
        )

        WeblogEntryView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview("With Content (Date Descending)") {
        let repository = WeblogRepositoryMother.makeWeblogRepository()
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateDescending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

    #Preview("With Content (Date Ascending)") {
        let repository = WeblogRepositoryMother.makeWeblogRepository()
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateAscending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

    #Preview("Without Content") {
        let repository = WeblogRepositoryMother.makeWeblogRepository(count: 0)
        let environment = WeblogEnvironmentMother.makeWeblogEnvironment()

        WeblogEntriesListView(
            viewModel: .init(
                address: "otaviocc",
                sort: .publishedDateAscending,
                repository: repository
            )
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContext(repository.entriesContainer.mainContext)
    }

#endif
