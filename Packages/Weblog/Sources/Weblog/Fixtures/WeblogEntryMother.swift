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
            for index in 0..<count {
                let entry = WeblogEntry(
                    id: "entry-\(index)",
                    title: "Test Entry \(index)",
                    body: "This is the body for test entry \(index). Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    date: Double(1_700_000_000 + (index * 86400)),
                    status: index % 3 == 0 ? "draft" : "published",
                    location: "test-entry-\(index)",
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    entry
                )
            }
        }
    }

#endif
