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

/// A protocol for creating weblog persistence service instances.
///
/// This protocol defines the factory interface for creating properly configured
/// weblog persistence services with their required dependencies. The factory
/// pattern abstracts the complex initialization of persistence services and enables
/// dependency injection of different storage configurations and session services.
///
/// Weblog persistence services handle local storage and retrieval of blog content
/// using Swift Data framework. The service manages a SwiftData model container
/// and provides data persistence capabilities for weblog entry entities including
/// blog posts, metadata, categories, tags, and draft versions. Implementations
/// should configure the service with appropriate session services and storage options.
///
/// ## Usage Example
/// ```swift
/// let factory: WeblogPersistenceServiceFactoryProtocol = WeblogPersistenceServiceFactory()
/// let service = factory.makeWeblogPersistenceService(
///     inMemory: false,
///     authSessionService: authSessionService
/// )
/// ```
public protocol WeblogPersistenceServiceFactoryProtocol {

    /// Creates a new weblog persistence service instance.
    ///
    /// This method constructs a fully configured weblog persistence service with
    /// the provided configuration and session service. The persistence service manages
    /// local storage of blog entries, drafts, and metadata using Swift Data framework.
    ///
    /// The created service provides:
    /// - Swift Data model container management for WeblogEntry entities
    /// - Local storage and retrieval of blog posts and metadata
    /// - Integration with session state for user-specific blog collections
    /// - Draft management and revision history for blog editing workflows
    /// - Category and tag persistence for content organization
    /// - Configurable in-memory or persistent storage options
    /// - Blog settings and configuration caching
    /// - Proper error handling for storage operations
    ///
    /// - Parameters:
    ///   - inMemory: Whether to use in-memory storage (true) or persistent storage (false).
    ///   - authSessionService: The session service for managing authentication state.
    /// - Returns: A configured `WeblogPersistenceServiceProtocol` instance ready for use.
    func makeWeblogPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> WeblogPersistenceServiceProtocol
}

public struct WeblogPersistenceServiceFactory: WeblogPersistenceServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeWeblogPersistenceService(
        inMemory: Bool,
        authSessionService: any AuthSessionServiceProtocol
    ) -> any WeblogPersistenceServiceProtocol {
        let configuration = ModelConfiguration(
            "entries",
            schema: .init([WeblogEntry.self, WeblogTag.self]),
            isStoredInMemoryOnly: inMemory,
            allowsSave: true
        )

        let container = try? ModelContainer(
            for: WeblogEntry.self, WeblogTag.self,
            configurations: configuration
        )

        guard let container else {
            fatalError("failed to create the storage container")
        }

        return WeblogPersistenceService(
            container: container,
            authSessionService: authSessionService
        )
    }
}
