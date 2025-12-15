import StatusNetworkService
import StatusPersistenceService

extension StorableStatus {

    init(
        statusResponse: StatusResponse
    ) {
        self.init(
            id: statusResponse.id,
            username: statusResponse.address,
            timestamp: Double(statusResponse.timestamp) ?? 0,
            icon: statusResponse.emojiIcon,
            content: statusResponse.markdownContent,
            externalURL: statusResponse.externalURL
        )
    }
}
