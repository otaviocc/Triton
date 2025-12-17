import Foundation
import MicroClient
import OMGAPI

/// A protocol for network operations related to account information updates.
///
/// This protocol defines the interface for fetching account information and associated
/// addresses from the remote server. It provides the network layer functionality needed
/// to keep local account information synchronized with the server state.
///
/// The protocol supports fetching both core account information (name, email, creation date)
/// and associated addresses (domains) with their registration and expiration details.
/// This information is typically used to populate user profile displays and manage
/// domain/address ownership information.
public protocol AccountUpdateNetworkServiceProtocol: Sendable {

    /// Fetches the current account information from the server.
    ///
    /// This method retrieves the authenticated user's account details including
    /// their name, email address, and account creation date. The information
    /// is fetched from the server's account information endpoint.
    ///
    /// - Returns: An `AccountResponse` containing the user's account information.
    /// - Throws: Network errors, authentication errors, or API errors if the fetch fails.
    func fetchAccount() async throws -> AccountResponse

    /// Fetches all addresses associated with the current account.
    ///
    /// This method retrieves the list of addresses that are registered
    /// to the authenticated user's account. Each address includes registration
    /// and expiration dates, providing complete ownership information.
    ///
    /// - Returns: An array of `AddressResponse` objects representing the user's addresses.
    /// - Throws: Network errors, authentication errors, or API errors if the fetch fails.
    func fetchAddresses() async throws -> [AddressResponse]
}

actor AccountUpdateNetworkService: AccountUpdateNetworkServiceProtocol {

    // MARK: - Properties

    private let networkClient: NetworkClientProtocol

    // MARK: - Lifecycle

    init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient
    }

    // MARK: - Public

    func fetchAccount() async throws -> AccountResponse {
        let accountResponse = try await networkClient.run(
            AccountRequestFactory.makeAccountInformationRequest()
        )

        return AccountResponse(
            response: accountResponse.value.response
        )
    }

    func fetchAddresses() async throws -> [AddressResponse] {
        let addressesResponse = try await networkClient.run(
            AccountRequestFactory.makeAccountAddressesRequest()
        )

        return addressesResponse.value.response.map(AddressResponse.init)
    }
}

// MARK: - Private

private extension AccountResponse {

    /// Initializes the `AccountResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    ///
    /// If the name from the API response is `nil` or empty, it defaults to "Anonymous"
    /// to ensure all layers of the application work with a non-optional name value.
    ///
    /// - Parameter response: The network model to be mapped.
    init(
        response: AccountInformationResponse.Response
    ) {
        if let responseName = response.name, !responseName.isEmpty {
            name = responseName
        } else {
            name = "Anonymous"
        }
        email = response.email
        unixEpochTime = response.created.unixEpochTime
    }
}

private extension AddressResponse {

    /// Initializes the `AddressResponse` model from the network response
    /// model, so that the client doesn't depend on network models.
    /// - Parameter response: The network model to be mapped.
    init(
        response: AccountAddressesResponse.AccountAddressResponse
    ) {
        address = response.address
        unixEpochTime = response.registration.unixEpochTime
        expireUnixEpochTime = response.expiration.unixEpochTime
    }
}
