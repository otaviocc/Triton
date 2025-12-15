#if DEBUG

    import SessionServiceInterface

    enum EditorViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeEditorViewModel() -> EditorViewModel {
            .init(
                address: "alice",
                body: "# This is the title\n\nThis is the body...",
                date: .init(),
                entryID: nil,
                repository: WeblogRepositoryMother.makeWeblogRepository()
            )
        }
    }

#endif
