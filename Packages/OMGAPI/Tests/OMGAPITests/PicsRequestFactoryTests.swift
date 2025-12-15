import Foundation
import Testing
@testable import OMGAPI

@Suite("PicsRequestFactory Tests")
struct PicsRequestFactoryTests {

    @Test("It should create all pictures request with correct configuration")
    func makeAllPicturesRequest_createsRequest() {
        // When
        let request = PicsRequestFactory.makeAllPicturesRequest()

        // Then
        #expect(
            request.path == "/pics",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create user pictures request with correct configuration")
    func makePicturesRequest_createsRequest() {
        // Given
        let address = "alice"

        // When
        let request = PicsRequestFactory.makePicturesRequest(address: address)

        // Then
        #expect(
            request.path == "/address/alice/pics",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create picture upload request with correct configuration")
    func makeUploadPictureRequest_createsRequest() {
        // Given
        let address = "bob"
        let imageData = Data([0x89, 0x50, 0x4E, 0x47]) // PNG header bytes

        // When
        let request = PicsRequestFactory.makeUploadPictureRequest(
            address: address,
            data: imageData
        )

        // Then
        #expect(
            request.path == "/address/bob/pics/upload",
            "It should use correct API path with address"
        )

        #expect(
            request.method == .post,
            "It should use POST method"
        )

        #expect(
            request.body?.pic == imageData.base64EncodedString(),
            "It should include base64-encoded image data in request body"
        )
    }

    @Test("It should create picture edit request with isHidden true")
    func makeEditPictureRequest_withIsHiddenTrue_createsRequest() {
        // Given
        let address = "charlie"
        let pictureID = "pic-123"
        let caption = "My beautiful sunset"
        let alt = "Sunset over the ocean"
        let isHidden = true

        // When
        let request = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            caption: caption,
            alt: alt,
            isHidden: isHidden
        )

        // Then
        #expect(
            request.path == "/address/charlie/pics/pic-123",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.method == .put,
            "It should use PUT method"
        )

        #expect(
            request.body?.caption == caption,
            "It should include caption in request body"
        )

        #expect(
            request.body?.alt == alt,
            "It should include alt text in request body"
        )

        #expect(
            request.body?.isHidden == true,
            "It should include isHidden as true in request body"
        )
    }

    @Test("It should create picture edit request with isHidden false converted to nil")
    func makeEditPictureRequest_withIsHiddenFalse_createsRequestWithNil() {
        // Given
        let address = "charlie"
        let pictureID = "pic-456"
        let caption = "Visible picture"
        let isHidden = false

        // When
        let request = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            caption: caption,
            isHidden: isHidden
        )

        // Then
        #expect(
            request.path == "/address/charlie/pics/pic-456",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.body?.isHidden == nil,
            "It should convert isHidden false to nil as workaround"
        )
    }

    @Test("It should create picture edit request with only caption")
    func makeEditPictureRequest_withOnlyCaption_createsRequest() {
        // Given
        let address = "dave"
        let pictureID = "pic-456"
        let caption = "Updated caption"

        // When
        let request = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            caption: caption
        )

        // Then
        #expect(
            request.path == "/address/dave/pics/pic-456",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.method == .put,
            "It should use PUT method"
        )

        #expect(
            request.body?.caption == caption,
            "It should include caption in request body"
        )

        #expect(
            request.body?.alt == nil,
            "It should have nil alt text when not provided"
        )

        #expect(
            request.body?.isHidden == nil,
            "It should have nil isHidden when not provided"
        )
    }

    @Test("It should create picture edit request with only tags")
    func makeEditPictureRequest_withOnlyTags_createsRequest() {
        // Given
        let address = "dave"
        let pictureID = "pic-456"
        let tags = ["tag1", "tag2"]

        // When
        let request = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            tags: tags
        )

        // Then
        #expect(
            request.path == "/address/dave/pics/pic-456",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.method == .put,
            "It should use PUT method"
        )

        #expect(
            request.body?.tags == tags.joined(separator: ","),
            "It should include tags in request body"
        )

        #expect(
            request.body?.caption == nil,
            "It should have nil caption when not provided"
        )

        #expect(
            request.body?.alt == nil,
            "It should have nil alt text when not provided"
        )

        #expect(
            request.body?.isHidden == nil,
            "It should have nil isHidden when not provided"
        )
    }

    @Test("It should create picture edit request with empty tags array")
    func makeEditPictureRequest_withOnlyWithEmptyTagsArray_createsRequest() {
        // Given
        let address = "dave"
        let pictureID = "pic-456"
        let tags: [String] = []

        // When
        let request = PicsRequestFactory.makeEditPictureRequest(
            address: address,
            pictureID: pictureID,
            tags: tags
        )

        // Then
        #expect(
            request.path == "/address/dave/pics/pic-456",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.method == .put,
            "It should use PUT method"
        )

        #expect(
            request.body?.tags == "",
            "It should include tags in request body"
        )

        #expect(
            request.body?.caption == nil,
            "It should have nil caption when not provided"
        )

        #expect(
            request.body?.alt == nil,
            "It should have nil alt text when not provided"
        )

        #expect(
            request.body?.isHidden == nil,
            "It should have nil isHidden when not provided"
        )
    }

    @Test("It should create picture deletion request with correct configuration")
    func makeDeletePictureRequest_createsRequest() {
        // Given
        let address = "eve"
        let pictureID = "pic-789"

        // When
        let request = PicsRequestFactory.makeDeletePictureRequest(
            address: address,
            pictureID: pictureID
        )

        // Then
        #expect(
            request.path == "/address/eve/pics/pic-789",
            "It should use correct API path with address and picture ID"
        )

        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }
}
