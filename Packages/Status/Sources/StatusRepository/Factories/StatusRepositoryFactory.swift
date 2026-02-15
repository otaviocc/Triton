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

import StatusNetworkService
import StatusPersistenceService

/// A protocol for creating status repository instances.
///
/// This protocol defines the factory interface for creating properly configured
/// status repositories with their required network and persistence service dependencies.
/// The factory pattern abstracts the complex initialization of repositories and enables
/// dependency injection of different service implementations.
///
/// Status repositories coordinate between network and persistence layers to provide
/// a unified interface for status management operations. They handle data synchronization,
/// caching strategies, and provide seamless integration between remote API calls and
/// local data storage for status updates and timeline management.
///
/// ## Usage Example
/// ```swift
/// let factory: StatusRepositoryFactoryProtocol = StatusRepositoryFactory()
/// let repository = factory.makeStatusRepository(
///     networkService: networkService,
///     persistenceService: persistenceService
/// )
/// ```
public protocol StatusRepositoryFactoryProtocol {

    /// Creates a new status repository instance.
    ///
    /// This method constructs a fully configured status repository with the provided
    /// network and persistence services. The repository coordinates between these
    /// services to provide comprehensive status management capabilities including
    /// data synchronization, offline support, and caching strategies.
    ///
    /// The created repository provides:
    /// - Status creation and publishing with offline queue support
    /// - Timeline retrieval with local caching and remote synchronization
    /// - Status editing and update operations
    /// - Status deletion with proper cleanup
    /// - Data synchronization between local storage and remote endpoints
    /// - Conflict resolution for concurrent modifications
    ///
    /// - Parameters:
    ///   - networkService: The network service for remote status operations.
    ///   - persistenceService: The persistence service for local status storage.
    /// - Returns: A configured `StatusRepositoryProtocol` instance ready for use.
    func makeStatusRepository(
        networkService: StatusNetworkServiceProtocol,
        persistenceService: StatusPersistenceServiceProtocol
    ) -> StatusRepositoryProtocol
}

public struct StatusRepositoryFactory: StatusRepositoryFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeStatusRepository(
        networkService: StatusNetworkServiceProtocol,
        persistenceService: StatusPersistenceServiceProtocol
    ) -> StatusRepositoryProtocol {
        StatusRepository(
            networkService: networkService,
            persistenceService: persistenceService
        )
    }
}
