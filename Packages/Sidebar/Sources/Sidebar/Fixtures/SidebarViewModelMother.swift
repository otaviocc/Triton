#if DEBUG

    import AuthSessionServiceInterface

    enum SidebarViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeSidebarViewModel(
            loggedIn: Bool = false
        ) -> SidebarViewModel {
            .init(
                authSessionService: AuthSessionServiceMother.makeAuthSessionService(
                    loggedIn: loggedIn
                )
            )
        }
    }

#endif
