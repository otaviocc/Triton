#if DEBUG

    import NowNetworkService

    enum NowResponseMother {

        // MARK: - Public

        static func makeNowResponse() -> NowResponse {
            .init(
                markdownContent: "Foobar",
                updated: 1,
                listed: 1
            )
        }
    }

#endif
