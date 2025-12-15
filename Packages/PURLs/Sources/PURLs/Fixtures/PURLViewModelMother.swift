#if DEBUG

    import Foundation

    enum PURLViewModelMother {

        @MainActor
        static func makePURLViewModel() -> PURLViewModel {
            .init(
                title: "omglol",
                originalURL: URL(string: "https://home.omg.lol/referred-by/otaviocc")!,
                permanentURL: URL(string: "https://url.otavio.lol/omglol")!,
                address: "alice",
                repository: PURLsRepositoryMother.makePURLsRepository(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
