extension WeblogEntry {

    static func makeEntry(
        storableEntry: StorableEntry
    ) -> WeblogEntry {
        .init(
            id: storableEntry.id,
            title: storableEntry.title,
            body: storableEntry.body,
            date: storableEntry.date,
            status: storableEntry.status,
            location: storableEntry.location,
            address: storableEntry.address,
            tags: storableEntry.tags.isEmpty ? nil : storableEntry.tags
        )
    }
}
