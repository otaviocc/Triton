import NowNetworkService
import NowPersistenceService

extension StorableNow {

    init(
        address: String,
        nowResponse: NowResponse
    ) {
        self.init(
            markdownContent: nowResponse.markdownContent,
            timestamp: Double(nowResponse.updated),
            listed: nowResponse.listed == 1,
            submitted: true,
            address: address
        )
    }
}
