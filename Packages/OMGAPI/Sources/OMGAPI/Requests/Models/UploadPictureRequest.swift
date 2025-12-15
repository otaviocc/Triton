import Foundation

public struct UploadPictureRequest: Encodable, Sendable {

    // MARK: - Properties

    let pic: String

    // MARK: - Lifecycle

    init(
        pic: String
    ) {
        self.pic = pic
    }
}
