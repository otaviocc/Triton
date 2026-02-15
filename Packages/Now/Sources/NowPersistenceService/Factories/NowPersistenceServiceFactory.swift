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

import AuthSessionServiceInterface
import SwiftData

/// A protocol for creating "Now" page persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// "Now" page persistence services with their required dependencies. The factory
/// pattern abstracts the complex initialization of persistence services and enables
/// dependency injection of different storage configurations and session services.
///
/// Now page persistence services handle local storage and retrieval of "Now" page
/// content using Swift Data framework. The service manages a SwiftData model container
/// and provides data persistence capabilities for current activity entities.
/// Implementations should configure the service with appropriate session services
/// and storage options for user context and data management.
///
/// ## Usage Example
/// ```swift
/// let factory: NowPersistenceServiceFactoryProtocol = NowPersistenceServiceFactory()
/// let service = factory.makeNowPersistenceService(
///     inMemory: false,
///     authSessionService: authSessionService
/// )
/// ```
public protocol NowPersistenceServiceFactoryProtocol {

    /// Creates a new "Now" page persistence service instance.
    ///
    /// This method constructs a fully configured "Now" page persistence service with
    /// the provided configuration and session service. The persistence service manages
    /// local storage of "Now" page content and current activity using Swift Data framework.
    ///
    /// The created service provides:
    /// - Swift Data model container management for Now entities
    /// - Local storage and retrieval of current activity content
    /// - Integration with session state for user-specific data management
    /// - Configurable in-memory or persistent storage options
    /// - Proper error handling for storage operations
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `NowPersistenceServiceProtocol` instance ready for use.
    func makeNowPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> NowPersistenceServiceProtocol
}

public struct NowPersistenceServiceFactory: NowPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeNowPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> NowPersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "now",
            schema: .init([Now.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: Now.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return NowPersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
