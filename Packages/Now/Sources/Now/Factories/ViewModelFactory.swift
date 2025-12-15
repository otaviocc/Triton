import MicroContainer
import NowPersistenceService
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
    func makeNowAppViewModel() -> NowAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makeNowViewModel(
        nowPage: Now,
        isCurrent: Bool
    ) -> NowViewModel {
        .init(
            markdown: nowPage.markdown,
            timestamp: nowPage.timestamp,
            listed: nowPage.listed,
            address: nowPage.address,
            isCurrent: isCurrent
        )
    }

    @MainActor
    func makeNowListViewModel(
        address: SelectedAddress
    ) -> NowListViewModel {
        .init(
            address: address,
            repository: container.resolve()
        )
    }

    @MainActor
    func makeEditorViewModel(
        address: String,
        content: String,
        isListed: Bool
    ) -> EditorViewModel {
        .init(
            address: address,
            content: content,
            isListed: isListed,
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
