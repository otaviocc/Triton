import PURLsNetworkService
import PURLsPersistenceService

extension StorablePURL {

    init(
        address: String,
        purlResponse: PURLResponse
    ) {
        self.init(
            name: purlResponse.name,
            url: purlResponse.url,
            address: address
        )
    }
}
