#if DEBUG

    import PastebinRepository
    import SessionServiceInterface

    enum EditPasteViewMother {

        // MARK: - Public

        @MainActor
        static func makeEditPasteViewModel() -> EditPasteViewModel {
            .init(
                address: "alice",
                title: "Title",
                content: "Content",
                isListed: false,
                repository: PastebinRepositoryMother.makePastebinRepository()
            )
        }
    }

#endif
