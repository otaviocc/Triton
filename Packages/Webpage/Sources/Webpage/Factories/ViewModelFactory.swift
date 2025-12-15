import MicroContainer
import SessionServiceInterface
import SwiftUI
import WebpagePersistenceService

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
    func webpageAppViewModel() -> WebpageAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makeWebpageViewModel(
        webpage: Webpage,
        isCurrent: Bool
    ) -> WebpageViewModel {
        .init(
            markdown: webpage.markdown,
            timestamp: webpage.timestamp,
            address: webpage.address,
            isCurrent: isCurrent
        )
    }

    @MainActor
    func makeWebpageListViewModel(
        address: SelectedAddress
    ) -> WebpageListViewModel {
        .init(
            address: address,
            repository: container.resolve()
        )
    }

    @MainActor
    func makeEditorViewModel(
        address: String,
        content: String
    ) -> EditorViewModel {
        .init(
            address: address,
            content: content,
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
