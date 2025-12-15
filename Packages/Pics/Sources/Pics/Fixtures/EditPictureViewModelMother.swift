#if DEBUG

    import Foundation
    import SessionServiceInterface

    enum EditPictureViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeEditPictureViewModel(
            caption: String? = nil,
            altText: String? = nil,
            tags: [String]? = nil,
            isHidden: Bool? = nil,
            imageData: Data? = nil
        ) -> EditPictureViewModel {
            let viewModel = EditPictureViewModel(
                address: "alice",
                tags: tags ?? [],
                repository: PicsRepositoryMother.makePicsRepository()
            )

            if let caption {
                viewModel.caption = caption
            }

            if let altText {
                viewModel.altText = altText
            }

            return viewModel
        }
    }

#endif
