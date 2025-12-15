#if DEBUG

    import PastebinPersistenceService
    import SwiftData

    extension Paste {

        // MARK: - Public

        @MainActor
        static func makePaste(
            count: Int,
            in container: ModelContainer
        ) {
            for i in 0..<count {
                let paste = Paste(
                    title: "paste\(i).md",
                    content: "hello, world!",
                    timestamp: 123_123_123,
                    address: "otaviocc",
                    listed: i % 2 == 0
                )

                container.mainContext.insert(
                    paste
                )
            }
        }
    }

#endif
