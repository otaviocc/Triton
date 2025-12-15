#if DEBUG

    import SessionServiceInterface

    enum AddPURLViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeAddPURLViewModel(
            name: String = "",
            urlString: String = ""
        ) -> AddPURLViewModel {
            .init(
                name: name,
                urlString: urlString,
                repository: PURLsRepositoryMother.makePURLsRepository(),
                sessionService: SessionServiceMother.makeSessionService()
            )
        }
    }

#endif
