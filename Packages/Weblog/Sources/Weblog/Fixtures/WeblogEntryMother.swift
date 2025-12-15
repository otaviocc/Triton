#if DEBUG

    import SwiftData
    import WeblogPersistenceService

    extension WeblogEntry {

        // MARK: - Public

        @MainActor
        static func makeWeblogEntry(
            count: Int,
            in container: ModelContainer
        ) {
            for i in 0..<count {
                let entry = WeblogEntry(
                    id: "entry-\(i)",
                    title: "Test Entry \(i)",
                    body: "This is the body for test entry \(i). Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    date: Double(1_700_000_000 + (i * 86400)),
                    status: i % 3 == 0 ? "draft" : "published",
                    location: "test-entry-\(i)",
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    entry
                )
            }
        }
    }

#endif
