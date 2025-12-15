import Testing
@testable import OMGAPI

@Suite("AccountRequestFactory Tests")
struct AccountRequestFactoryTests {

    @Test("It should create account information request with correct configuration")
    func makeAccountInformationRequest_createsRequest() {
        // When
        let request = AccountRequestFactory.makeAccountInformationRequest()

        // Then
        #expect(
            request.path == "/account/application/info",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create account addresses request with correct configuration")
    func makeAccountAddressesRequest_createsRequest() {
        // When
        let request = AccountRequestFactory.makeAccountAddressesRequest()

        // Then
        #expect(
            request.path == "/account/application/addresses",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }
}
