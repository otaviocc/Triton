extension Now {

    static func makeNow(
        storableNow: StorableNow
    ) -> Now {
        .init(
            listed: storableNow.listed,
            markdown: storableNow.markdownContent,
            submitted: storableNow.submitted,
            timestamp: storableNow.timestamp,
            address: storableNow.address
        )
    }
}
