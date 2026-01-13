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
            (0..<count).map { index in
                makeEntryResponse(
                    id: "entry-\(index)",
                    location: "test-entry-\(index)",
                    date: Double(1_700_000_000 + (index * 86400)),
                    status: index % 3 == 0 ? "draft" : "published",
                    title: "Test Entry \(index)",
                    body: "Content for test entry \(index)"
                )
            }
        }
    }

#endif
