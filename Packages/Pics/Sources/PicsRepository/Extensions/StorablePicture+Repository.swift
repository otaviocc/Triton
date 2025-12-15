import PicsNetworkService
import PicsPersistenceService

extension StorablePicture {

    init(
        pictureResponse: PictureResponse
    ) {
        self.init(
            id: pictureResponse.id,
            address: pictureResponse.address,
            created: pictureResponse.created,
            mime: pictureResponse.mime,
            size: pictureResponse.size,
            url: pictureResponse.url,
            somePicsURL: pictureResponse.somePicsURL,
            description: pictureResponse.description,
            alt: pictureResponse.alt,
            tags: pictureResponse.tags
        )
    }
}
