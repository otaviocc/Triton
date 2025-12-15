import MicroContainer
import PastebinPersistenceService
import SessionServiceInterface
import SwiftUI

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
    func makePastebinAppViewModel() -> PastebinAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makePastesListViewModel(
        address: SelectedAddress,
        sort: PastesListSort
    ) -> PastesListViewModel {
        .init(
            address: address,
            sort: sort,
            repository: container.resolve()
        )
    }

    @MainActor
    func makePasteViewModel(
        paste: Paste
    ) -> PasteViewModel {
        .init(
            paste: paste,
            repository: container.resolve(),
            clipboardService: container.resolve()
        )
    }

    @MainActor
    func makeEditorViewModel(
        address: String,
        title: String,
        content: String,
        isListed: Bool
    ) -> EditPasteViewModel {
        .init(
            address: address,
            title: title,
            content: content,
            isListed: isListed,
            repository: container.resolve()
        )
    }

    @MainActor
    func makeCreatePasteViewModel() -> CreatePasteViewModel {
        .init(
            repository: container.resolve(),
            sessionService: container.resolve()
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
