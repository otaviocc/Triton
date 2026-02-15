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

import Foundation
import MicroContainer
import SessionServiceInterface
import SwiftUI
import WeblogPersistenceService

final class ViewModelFactory: Sendable {

    // MARK: - Properties

    private let container: DependencyContainer

    // MARK: - Lifecycle

    init(
        container: DependencyContainer
    ) {
        self.container = container
    }

    // MARK: - Public

    @MainActor
    func makeWeblogAppViewModel() -> WeblogAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makeWeblogEntryViewModel(
        entry: WeblogEntry
    ) -> WeblogEntryViewModel {
        .init(
            id: entry.id,
            title: entry.title,
            body: entry.body,
            status: entry.status,
            timestamp: entry.date,
            address: entry.address,
            location: entry.location,
            tags: entry.tags ?? [],
            repository: container.resolve(),
            clipboardService: container.resolve()
        )
    }

    @MainActor
    func makeWeblogEntriesListViewModel(
        address: SelectedAddress,
        sort: WeblogEntriesListSort
    ) -> WeblogEntriesListViewModel {
        .init(
            address: address,
            sort: sort,
            repository: container.resolve()
        )
    }

    @MainActor
    func makeEditWeblogEntryViewModel(
        address: String,
        body: String,
        date: Date,
        entryID: String?,
        status: WeblogEntryStatus,
        tags: [String]
    ) -> EditorViewModel {
        .init(
            address: address,
            body: body,
            date: date,
            entryID: entryID,
            status: status,
            tags: tags,
            repository: container.resolve()
        )
    }
}

// MARK: - Environment

extension EnvironmentValues {

    @Entry var viewModelFactory: ViewModelFactory = .placeholder
}

extension ViewModelFactory {

    static let placeholder = ViewModelFactory(
        container: .init()
    )
}
