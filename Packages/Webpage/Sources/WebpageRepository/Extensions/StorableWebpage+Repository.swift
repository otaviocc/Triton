import WebpageNetworkService
import WebpagePersistenceService

extension StorableWebpage {

    init(
        address: String,
        webpage: WebResponse
    ) {
        self.init(
            markdownContent: webpage.markdownContent,
            timestamp: webpage.timestamp,
            address: address
        )
    }
}
