import PastebinNetworkService
import PastebinPersistenceService

extension StorablePaste {

    init(
        address: String,
        pasteResponse: PasteResponse
    ) {
        self.init(
            title: pasteResponse.title,
            content: pasteResponse.content,
            timestamp: Double(pasteResponse.modifiedOn),
            address: address,
            listed: pasteResponse.listed
        )
    }
}
