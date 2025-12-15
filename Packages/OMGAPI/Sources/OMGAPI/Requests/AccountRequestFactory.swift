import MicroClient

/// A factory for creating account-related API requests.
///
/// `AccountRequestFactory` provides static methods for creating pre-configured
/// network requests to retrieve account information from the OMG.LOL API.
/// This factory encapsulates the API endpoints, HTTP methods, and response
/// types needed for account-related operations.
///
/// The factory follows a static enum pattern, providing namespace organization
/// without requiring instantiation. Each method returns a fully configured
/// `NetworkRequest` that can be executed by a network client.
///
/// ## Usage Example
/// ```swift
/// // Create and execute account information request
/// let request = AccountRequestFactory.makeAccountInformationRequest()
/// let response = try await networkClient.run(request)
/// print("Account: \(response.response.name)")
///
/// // Create and execute addresses request
/// let addressRequest = AccountRequestFactory.makeAccountAddressesRequest()
/// let addressResponse = try await networkClient.run(addressRequest)
/// ```
///
/// ## API Integration
/// These requests integrate with the OMG.LOL account management endpoints:
/// - `/account/application/info` - Retrieve account information
/// - `/account/application/addresses` - Retrieve associated addresses
///
/// Both requests require authentication and will use the network client's
/// configured authentication interceptor to include bearer tokens.
public enum AccountRequestFactory {

    /// Creates a request to retrieve the authenticated user's account information.
    ///
    /// This method builds a GET request to fetch complete account details including
    /// the user's name, email address, and account creation date. The request
    /// requires authentication and will include the bearer token automatically
    /// via the network client's authentication interceptor.
    ///
    /// The response includes both request metadata (status, success flag) and
    /// the actual account information in a structured format.
    ///
    /// - Returns: A configured network request for retrieving account information
    public static func makeAccountInformationRequest(
    ) -> NetworkRequest<VoidRequest, AccountInformationResponse> {
        .init(
            path: "/account/application/info",
            method: .get
        )
    }

    /// Creates a request to retrieve all addresses associated with the account.
    ///
    /// This method builds a GET request to fetch the complete list of addresses
    /// (usernames) registered to the authenticated user's account. Each address
    /// includes registration and expiration information for renewal management.
    ///
    /// The request requires authentication and will include the bearer token
    /// automatically. The response contains an array of address objects with
    /// their associated metadata.
    ///
    /// - Returns: A configured network request for retrieving account addresses
    public static func makeAccountAddressesRequest(
    ) -> NetworkRequest<VoidRequest, AccountAddressesResponse> {
        .init(
            path: "/account/application/addresses",
            method: .get
        )
    }
}
