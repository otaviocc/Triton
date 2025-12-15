#if DEBUG

    import SwiftData
    import WebpagePersistenceService

    extension Webpage {

        // MARK: - Public

        @MainActor
        static func makeWebpage(
            count: Int,
            in container: ModelContainer
        ) {
            for i in 0..<count {
                let page = Webpage(
                    address: "otaviocc",
                    markdown: "Foobar \(i)",
                    timestamp: 123_123 * Double(i)
                )

                container.mainContext.insert(
                    page
                )
            }
        }
    }

#endif
