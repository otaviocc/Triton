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
            for i in 0..<count {
                let now = Now(
                    listed: true,
                    markdown: "Foobar \(i)",
                    submitted: true,
                    timestamp: 123_123 * Double(i),
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    now
                )
            }
        }
    }

#endif
