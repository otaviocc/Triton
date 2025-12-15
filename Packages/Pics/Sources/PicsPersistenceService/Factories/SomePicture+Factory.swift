extension SomePicture {

    static func makePicture(
        storablePicture: StorablePicture
    ) -> SomePicture {
        .init(
            id: storablePicture.id,
            address: storablePicture.address,
            created: storablePicture.created,
            mime: storablePicture.mime,
            size: storablePicture.size,
            url: storablePicture.url,
            somePicsURL: storablePicture.somePicsURL,
            caption: storablePicture.description,
            alt: storablePicture.alt,
            tags: storablePicture.tags
        )
    }
}
