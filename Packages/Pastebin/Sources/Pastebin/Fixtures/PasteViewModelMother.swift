#if DEBUG

    enum PasteViewModelMother {

        @MainActor
        static func makePasteViewModel(
            listed: Bool = true
        ) -> PasteViewModel {
            .init(
                title: "hello.swift",
                content: """
                func hello() -> String {
                    "Hello"
                }
                """,
                listed: listed,
                address: "otaviocc",
                repository: PastebinRepositoryMother.makePastebinRepository(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
