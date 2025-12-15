extension Status {

    static func makeStatus(
        statusPublic: StorableStatus
    ) -> Status {
        .init(
            username: statusPublic.username,
            statusID: statusPublic.id,
            timestamp: statusPublic.timestamp,
            icon: statusPublic.icon,
            content: statusPublic.content,
            externalURL: statusPublic.externalURL
        )
    }
}
