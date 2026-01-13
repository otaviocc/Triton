#if DEBUG

    import NowPersistenceService
    import SwiftData

    extension Now {

        // MARK: - Public

        @MainActor
        static func makeNow(
            count: Int,
            in container: ModelContainer
        ) {
            for index in 0..<count {
                let now = Now(
                    listed: true,
                    markdown: "Foobar \(index)",
                    submitted: true,
                    timestamp: 123_123 * Double(index),
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    now
                )
            }
        }
    }

#endif
