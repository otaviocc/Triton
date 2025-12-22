#if DEBUG

    import SessionServiceInterface

    enum EditorViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeEditorViewModel(
            status: WeblogEntryStatus = .draft,
            tags: [String] = []
        ) -> EditorViewModel {
            .init(
                address: "alice",
                body: "# This is the title\n\nThis is the body...",
                date: .init(),
                entryID: nil,
                status: status,
                tags: tags,
                repository: WeblogRepositoryMother.makeWeblogRepository()
            )
        }
    }

#endif
