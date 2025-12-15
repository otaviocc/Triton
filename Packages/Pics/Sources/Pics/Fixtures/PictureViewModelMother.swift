#if DEBUG

    import Foundation

    enum PictureViewModelMother {

        // MARK: - Public

        @MainActor
        static func makePictureViewModel(
            hasTitle: Bool = true
        ) -> PictureViewModel {
            .init(
                id: UUID().uuidString,
                timestamp: 1_700_000_000,
                title: hasTitle ? "Public bus interior with passengers, yellow pole, and wheelchair sign." : nil,
                photoURL: URL(string: "https://cdn.some.pics/otaviocc/68c94c4c8d334.jpg"),
                somePicsURL: nil,
                address: "otaviocc",
                repository: PicsRepositoryMother.makePicsRepository(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
