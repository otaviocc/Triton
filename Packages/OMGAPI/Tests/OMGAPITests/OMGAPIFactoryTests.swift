import Testing
@testable import OMGAPI

@Suite("OMGAPIFactory Tests")
struct OMGAPIFactoryTests {

    @Test("It should create a properly configured network client")
    func makeOMGAPIClient_createsClient() async throws {
        // Given
        let factory = OMGAPIFactory()
        let expectedToken = "test_token_123"

        // When
        let client = factory.makeOMGAPIClient {
            expectedToken
        }

        // Then
        let clientType = type(of: client)
        #expect(
            String(describing: clientType) == "NetworkClient",
            "It should create a NetworkClient instance"
        )
    }

    @Test("It should create a network client with nil token provider")
    func makeOMGAPIClient_withNilToken_createsClient() async throws {
        // Given
        let factory = OMGAPIFactory()

        // When
        let client = factory.makeOMGAPIClient {
            nil
        }

        // Then
        let clientType = type(of: client)
        #expect(
            String(describing: clientType) == "NetworkClient",
            "It should create a NetworkClient instance even with nil token"
        )
    }
}
