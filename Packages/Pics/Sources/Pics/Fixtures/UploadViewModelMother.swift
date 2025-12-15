#if DEBUG

    import Foundation
    import SessionServiceInterface

    enum UploadViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeUploadViewModel(
            caption: String? = nil,
            altText: String? = nil,
            isHidden: Bool? = nil,
            tags: [String]? = nil,
            imageData: Data? = nil
        ) -> UploadViewModel {
            let viewModel = UploadViewModel(
                repository: PicsRepositoryMother.makePicsRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )

            viewModel.imageData = imageData

            if let caption {
                viewModel.caption = caption
            }

            if let altText {
                viewModel.altText = altText
            }

            if let isHidden {
                viewModel.isHidden = isHidden
            }

            if let tags {
                tags.forEach { viewModel.addTag($0) }
            }

            return viewModel
        }
    }

#endif
