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
import Foundation
import SwiftData

/// A protocol for managing /now page persistence operations.
///
/// This protocol defines the interface for local storage operations of /now page content
/// using SwiftData. It handles storing /now page versions in the local database and
/// managing data cleanup when users log out.
///
/// The service maintains a versioned history of /now page content, storing multiple
/// versions with timestamps to support content history and change tracking. A limited
/// retention policy prevents unlimited storage growth while maintaining recent content
/// accessibility. All mutation operations are constrained to the main actor to ensure
/// thread safety with SwiftData operations and UI updates.
public protocol NowPersistenceServiceProtocol: AnyObject, Sendable {

    /// The SwiftData model container for /now page persistence.
    ///
    /// This container manages the SQLite database and provides the context
    /// for all SwiftData operations related to /now page storage. The container
    /// handles unique constraints and versioning for /now page content based
    /// on address and timestamp combinations.
    var container: ModelContainer { get }

    /// Stores a /now page version in the persistent container.
    ///
    /// This method inserts a new /now page content version into local storage.
    /// Each /now page is identified by its address and timestamp, creating a
    /// versioned history of content changes. The storage follows a limited
    /// retention policy (3 most recent versions) to prevent unlimited growth.
    ///
    /// If a /now page with the same address and timestamp already exists,
    /// the SwiftData unique constraints will handle the conflict appropriately.
    ///
    /// - Parameter nowPage: A `StorableNow` object containing the content and metadata to store.
    /// - Throws: SwiftData persistence errors or validation errors during storage.
    @MainActor
    func storeNowPage(
        nowPage: StorableNow
    ) throws
}

actor NowPersistenceService: NowPersistenceServiceProtocol {

    // MARK: - Properties

    let container: ModelContainer
    private let authSessionService: any AuthSessionServiceProtocol
    private var logoutObservationTask: Task<Void, Never>?

    // MARK: - Lifecycle

    init(
        container: ModelContainer,
        authSessionService: any AuthSessionServiceProtocol
    ) {
        self.container = container
        self.authSessionService = authSessionService

        Task { await setUpObservers() }
    }

    deinit {
        logoutObservationTask?.cancel()
    }

    // MARK: - Public

    @MainActor
    func storeNowPage(
        nowPage: StorableNow
    ) throws {
        let model = Now.makeNow(storableNow: nowPage)
        container.mainContext.insert(model)
        try container.mainContext.save()
    }

    // MARK: - Private

    private func setUpObservers() {
        logoutObservationTask = Task {
            for await _ in authSessionService.observeLogoutEvents() {
                Task { @MainActor [weak self] in
                    try self?.container.mainContext.delete(model: Now.self)
                    try self?.container.mainContext.save()
                }
            }
        }
    }
}
