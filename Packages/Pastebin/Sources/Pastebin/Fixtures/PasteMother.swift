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
            for index in 0..<count {
                let paste = Paste(
                    title: "paste\(index).md",
                    content: "hello, world!",
                    timestamp: 123_123_123,
                    address: "otaviocc",
                    listed: index % 2 == 0
                )

                container.mainContext.insert(
                    paste
                )
            }
        }
    }

#endif
