import Foundation
import MicroContainer
import PicsPersistenceService
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
    func makePicsAppViewModel() -> PicsAppViewModel {
        .init(
            authSessionService: container.resolve(),
            sessionService: container.resolve(),
            repository: container.resolve()
        )
    }

    @MainActor
    func makePicturesListViewModel(
        address: SelectedAddress
    ) -> PicturesListViewModel {
        .init(
            address: address,
            repository: container.resolve()
        )
    }

    @MainActor
    func makePictureViewModel(
        picture: SomePicture
    ) -> PictureViewModel {
        .init(
            id: picture.id,
            timestamp: picture.created,
            title: picture.caption,
            altText: picture.alt,
            photoURL: URL(string: picture.url),
            somePicsURL: URL(string: picture.somePicsURL),
            address: picture.address,
            tags: picture.tags,
            repository: container.resolve(),
            clipboardService: container.resolve()
        )
    }

    @MainActor
    func makeUploadViewModel() -> UploadViewModel {
        .init(
            repository: container.resolve(),
            sessionService: container.resolve()
        )
    }

    @MainActor
    func makeEditPictureViewModel(
        address: String,
        pictureID: String,
        caption: String,
        altText: String,
        tags: [String]
    ) -> EditPictureViewModel {
        .init(
            address: address,
            caption: caption,
            altText: altText,
            tags: tags,
            pictureID: pictureID,
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
