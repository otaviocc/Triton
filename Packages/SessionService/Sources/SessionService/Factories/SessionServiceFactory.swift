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

import Archiver
import Foundation
import SessionServiceInterface

/// A protocol for factories that create session service instances.
///
/// This protocol defines the interface for creating `SessionServiceProtocol`
/// implementations. It follows the factory pattern to encapsulate the creation
/// and configuration of session services, allowing different implementations
/// or configurations to be used without changing client code.
///
/// The factory pattern is particularly useful for dependency injection systems
/// where the concrete session service implementation might vary based on
/// configuration, testing needs, or runtime conditions.
///
/// ## Usage Example
/// ```swift
/// let factory: SessionServiceFactoryProtocol = SessionServiceFactory()
/// let sessionService = factory.makeSessionService()
/// ```
public protocol SessionServiceFactoryProtocol {

    /// Creates a new session service instance.
    ///
    /// This method constructs and configures a session service with all necessary
    /// dependencies and settings. The returned service is ready to manage user
    /// session state and provide account information to the application.
    ///
    /// - Returns: A configured session service that implements `SessionServiceProtocol`
    func makeSessionService() -> any SessionServiceProtocol
}

public struct SessionServiceFactory: SessionServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeSessionService() -> any SessionServiceProtocol {
        guard
            let accountArchiver = try? Archiver<CurrentAccount>(),
            let addressArchiver = try? Archiver<SelectedAddress>()
        else {
            fatalError("Couldn't initialize the account Archiver")
        }

        return SessionService(
            accountArchiver: accountArchiver,
            addressArchiver: addressArchiver
        )
    }
}
