// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public struct AccountAddressesResponse: Decodable, Sendable {

    // MARK: - Properties

    public let request: RequestResponse
    public let response: [AccountAddressResponse]
}

public extension AccountAddressesResponse {

    // MARK: - Nested types

    struct AccountAddressResponse: Decodable, Sendable {

        // MARK: - Properties

        public let address: String
        public let message: String
        public let registration: RegistrationResponse
        public let expiration: ExpirationResponse
    }
}

public extension AccountAddressesResponse.AccountAddressResponse {

    // MARK: - Nested types

    struct RegistrationResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case message
            case unixEpochTime = "unix_epoch_time"
        }

        // MARK: - Properties

        public let message: String
        public let unixEpochTime: Int
    }
}

public extension AccountAddressesResponse.AccountAddressResponse {

    // MARK: - Nested types

    struct ExpirationResponse: Decodable, Sendable {

        // MARK: - Nested types

        private enum CodingKeys: String, CodingKey {

            case expired
            case willExpire = "will_expire"
            case unixEpochTime = "unix_epoch_time"
        }

        // MARK: - Properties

        public let expired: Bool
        public let willExpire: Bool
        public let unixEpochTime: Int?
    }
}
