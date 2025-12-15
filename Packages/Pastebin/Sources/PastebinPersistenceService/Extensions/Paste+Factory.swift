extension Paste {

    static func makePaste(
        storablePaste: StorablePaste
    ) -> Paste {
        .init(
            title: storablePaste.title,
            content: storablePaste.content,
            timestamp: storablePaste.timestamp,
            address: storablePaste.address,
            listed: storablePaste.listed
        )
    }
}
