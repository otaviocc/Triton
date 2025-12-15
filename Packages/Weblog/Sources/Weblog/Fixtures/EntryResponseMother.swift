#if DEBUG

    import WeblogNetworkService

    enum EntryResponseMother {

        // MARK: - Public

        static func makeEntryResponse(
            id: String = "test-entry-id",
            location: String = "test-entry",
            date: Double = 1_700_000_000,
            status: String = "published",
            title: String = "Test Entry Title",
            body: String = "Test entry content goes here.",
            address: String = "otaviocc"
        ) -> EntryResponse {
            EntryResponse(
                id: id,
                location: location,
                date: date,
                status: status,
                title: title,
                body: body,
                address: address
            )
        }

        static func makeEntryResponses(count: Int = 5) -> [EntryResponse] {
            (0..<count).map { i in
                makeEntryResponse(
                    id: "entry-\(i)",
                    location: "test-entry-\(i)",
                    date: Double(1_700_000_000 + (i * 86400)),
                    status: i % 3 == 0 ? "draft" : "published",
                    title: "Test Entry \(i)",
                    body: "Content for test entry \(i)"
                )
            }
        }
    }

#endif
