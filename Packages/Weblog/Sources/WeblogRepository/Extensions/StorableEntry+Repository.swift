import WeblogNetworkService
import WeblogPersistenceService

extension StorableEntry {

    init(
        entryResponse: EntryResponse
    ) {
        self.init(
            id: entryResponse.id,
            title: entryResponse.title,
            body: entryResponse.body,
            date: entryResponse.date,
            status: entryResponse.status,
            location: entryResponse.location,
            address: entryResponse.address,
            tags: entryResponse.tags
        )
    }
}
