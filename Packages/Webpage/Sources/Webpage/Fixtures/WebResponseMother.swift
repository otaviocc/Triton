#if DEBUG

    import WebpageNetworkService

    enum WebResponseMother {

        // MARK: - Public

        static func makeWebResponse() -> WebResponse {
            .init(
                markdownContent: "Foobar",
                timestamp: 12_341_234
            )
        }
    }

#endif
