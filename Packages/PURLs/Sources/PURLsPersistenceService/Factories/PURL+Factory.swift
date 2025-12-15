extension PURL {

    static func makePURL(
        storablePURL: StorablePURL
    ) -> PURL {
        .init(
            name: storablePURL.name,
            url: storablePURL.url,
            address: storablePURL.address
        )
    }
}
