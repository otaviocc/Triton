#if DEBUG

    enum WeblogEntryViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeWeblogEntryViewModel(
            isDraft: Bool
        ) -> WeblogEntryViewModel {
            .init(
                id: "blogpostID",
                title: "This is a test",
                body: "This is just a test post. ",
                status: isDraft ? "draft" : "live",
                timestamp: 12_312_312,
                address: "otaviocc",
                location: "/2022/12/my-weblog-post",
                repository: WeblogRepositoryMother.makeWeblogRepository(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
