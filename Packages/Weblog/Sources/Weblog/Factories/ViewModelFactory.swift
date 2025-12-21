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
