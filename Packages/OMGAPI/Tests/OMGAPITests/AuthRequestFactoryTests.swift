import Foundation
import Testing
@testable import OMGAPI

@Suite("AuthRequestFactory Tests")
struct AuthRequestFactoryTests {

    @Test("It should create OAuth authorization URL with correct parameters")
    func makeOAuthCodeRequestURL_createsURL() throws {
        // When
        let url = try #require(
            AuthRequestFactory.makeOAuthCodeRequestURL(),
            "It should create a non-nil URL"
        )

        let components = try #require(
            URLComponents(url: url, resolvingAgainstBaseURL: true),
            "It should create valid URL components"
        )

        // Then
        #expect(
            components.scheme == "https",
            "It should use HTTPS scheme"
        )

        #expect(
            components.host == "home.omg.lol",
            "It should use correct host"
        )

        #expect(
            components.path == "/oauth/authorize",
            "It should use correct path"
        )

        let queryItems = try #require(
            components.queryItems,
            "It should have query items"
        )

        #expect(
            queryItems.contains(where: { $0.name == "client_id" }),
            "It should include client_id parameter"
        )

        #expect(
            queryItems.contains(where: { $0.name == "scope" && $0.value == "everything" }),
            "It should include scope parameter with 'everything' value"
        )

        #expect(
            queryItems.contains(where: { $0.name == "response_type" && $0.value == "code" }),
            "It should include response_type parameter with 'code' value"
        )

        #expect(
            queryItems.contains(where: { $0.name == "redirect_uri" }),
            "It should include redirect_uri parameter"
        )
    }

    @Test("It should create auth request with correct configuration")
    func makeAuthRequest_createsRequest() {
        // Given
        let authCode = "test_auth_code_123"

        // When
        let request = AuthRequestFactory.makeAuthRequest(code: authCode)

        // Then
        #expect(
            request.path == "/oauth",
            "It should use correct API path"
        )

        #expect(
            request.method == .get,
            "It should use GET method"
        )

        let queryItems = request.queryItems

        #expect(
            queryItems.contains(where: { $0.name == "client_id" }),
            "It should include client_id query parameter"
        )

        #expect(
            queryItems.contains(where: { $0.name == "client_secret" }),
            "It should include client_secret query parameter"
        )

        #expect(
            queryItems.contains(where: { $0.name == "redirect_uri" }),
            "It should include redirect_uri query parameter"
        )

        #expect(
            queryItems.contains(where: { $0.name == "code" && $0.value == authCode }),
            "It should include code query parameter with provided auth code"
        )

        #expect(
            queryItems.contains(where: { $0.name == "scope" && $0.value == "everything" }),
            "It should include scope query parameter"
        )
    }
}
