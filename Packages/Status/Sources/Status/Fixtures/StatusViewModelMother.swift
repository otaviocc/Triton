#if DEBUG

    import ClipboardService
    import Foundation

    enum StatusViewModelMother {

        // MARK: - Public

        @MainActor
        static func makeStatusViewModel() -> StatusViewModel {
            .init(
                address: "otaviocc",
                message: "Coding.",
                icon: "👨‍💻",
                statusURL: URL(string: "https://otavio.lol")!,
                timestamp: 1.0,
                replyURL: URL(string: "https://social.lol/@otaviocc"),
                repository: StatusRepositoryMother.makeStatusRepository(),
                clipboardService: ClipboardServiceMother.makeClipboardService()
            )
        }
    }

#endif
