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

import StatusPersistenceService
import StatusRepository
import SwiftData
import SwiftUI

struct StatusListView: View {

    // MARK: - Properties

    @State private var viewModel: StatusListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var statuses: [Status]
    @Query private var mutedAddresses: [MutedAddress]
    @Query private var mutedKeywords: [MutedKeyword]

    // MARK: - Lifecycle

    init(
        viewModel: StatusListViewModel
    ) {
        self.viewModel = viewModel

        _statuses = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Computed Properties

    private var filteredStatuses: [Status] {
        let addressSet = Set(mutedAddresses.map(\.address))
        let keywords = mutedKeywords.map(\.keyword)

        return statuses.filter {
            !$0.shouldFilter(
                mutedAddresses: addressSet,
                mutedKeywords: keywords
            )
        }
    }

    // MARK: - Public

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(filteredStatuses, id: \.id) { status in
                    StatusContainer(status: status)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct StatusContainer: View {

    // MARK: - Properties

    let status: Status
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makeStatusViewModel(
            status: status
        )

        StatusView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        let repository = StatusRepositoryMother.makeStatusRepository()
        let environment = StatusEnvironmentMother.makeStatusEnvironment()

        StatusListView(
            viewModel: .init(filter: .all)
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.statusesContainer)
        .frame(width: 360)
    }

#endif
