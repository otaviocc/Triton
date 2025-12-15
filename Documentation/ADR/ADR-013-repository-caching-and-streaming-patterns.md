# ADR-013: Repository Caching and Streaming Patterns

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

Repositories coordinate between NetworkService and PersistenceService layers, managing how data flows between remote APIs and local storage. I needed to establish patterns for:

1. **Data freshness:** When to fetch from network vs local cache
2. **Real-time updates:** How to keep UI synchronized with data changes
3. **Offline support:** Enable viewing cached data without network
4. **Conflict resolution:** Handle discrepancies between local and remote data
5. **User experience:** Minimize loading states and perceived latency

**Decision:**

I adopted a streaming-based caching pattern where repositories use AsyncStream to coordinate continuous data synchronization between network and persistence layers.

**Key Patterns:**

### 1. Stream-Based Synchronization

Repositories set up AsyncStream listeners that automatically persist incoming data:

```swift
actor PURLsRepository: PURLsRepositoryProtocol {
    private var streamTask: Task<Void, Never>?

    init(...) {
        Task {
            await startPURLsSync()
        }
    }

    private func startPURLsSync() {
        streamTask = Task { [weak self] in
            guard let self else { return }

            // Listen to network service stream
            for await purls in networkService.purlsStream() {
                guard !Task.isCancelled else { break }

                // Automatically persist incoming data
                let storablePurls = purls.map { purlResponse in
                    StorablePURL(address: current, purlResponse: purlResponse)
                }
                try await persistenceService.storePURLs(purls: storablePurls)
            }
        }
    }
}
```

### 2. Network Service Streams

NetworkServices emit data through AsyncStream, enabling reactive updates:

```swift
actor PURLsNetworkService: PURLsNetworkServiceProtocol {
    private let purlsStreamContinuation: AsyncStream<[PURLResponse]>.Continuation

    func fetchPURLs(for address: String) async throws {
        let request = OMGAPIFactory.makeAllPURLsRequest(for: address)
        let response: PURLsResponse = try await client.run(request)

        // Emit through stream for automatic caching
        continuation.yield(response.response.purls)
    }

    func purlsStream() -> AsyncStream<[PURLResponse]> {
        purlsAsyncStream
    }
}
```

### 3. SwiftData as Cache

PersistenceServices use SwiftData's ModelContainer, which views can query directly:

```swift
public protocol PURLsRepositoryProtocol: Sendable {
    var purlsContainer: ModelContainer { get }
    // ...
}

// Views query directly
@Query(sort: \StorablePURL.name) var purls: [StorablePURL]
```

**Caching Strategy:**

- **Write-through:** Network fetches automatically persist to Swift Data via streams
- **Read from cache:** Views use SwiftData @Query to read local data
- **Explicit refresh:** User-triggered or app lifecycle events fetch from network
- **No complex merge:** Network data is source of truth, overwrites local
- **Optimistic updates:** Some operations update UI immediately, then sync

**Benefits of Stream-Based Approach:**

1. **Automatic synchronization:** Data flows continuously from network to storage
2. **Decoupled coordination:** Repository doesn't manually call persistence after each network call
3. **Real-time updates:** UI stays synchronized via SwiftData observation
4. **Task management:** Stream tasks are managed in repository lifecycle
5. **Cancellation support:** Streams can be cancelled on repository deinit

**Conflict Resolution:**

Current approach: **Server wins** (last-write-wins)
- Network data always overwrites local cache
- No complex merge logic
- Suitable for single-user, single-device scenarios
- Conflicts rare due to API design

**Cache Invalidation:**

- **Explicit fetch:** Repository `fetchPURLs()` method triggers network call
- **Lifecycle events:** App foreground, user login trigger refreshes
- **Mutation operations:** Create/delete operations automatically refresh via stream
- **No TTL:** Data remains valid until explicitly refreshed

**Consequences:**

### Positive

- **Reactive UI:** SwiftData observation keeps views updated automatically
- **Offline viewing:** Local cache available without network
- **Clean coordination:** Streaming pattern reduces manual orchestration
- **Type safety:** @Model types provide compile-time safety
- **Performance:** Views read from local SwiftData, not waiting for network

### Negative

- **Memory:** Stream tasks run continuously during repository lifetime
- **Complexity:** Async stream coordination requires understanding async patterns
- **Limited offline:** Can't create/modify data offline (server is source of truth)

### Neutral

- **Conflict resolution:** Simple strategy works for current use case
- **Cache size:** No automatic cleanup, relies on periodic full refreshes

**When to Fetch:**

1. **User-initiated:** Pull-to-refresh, explicit button taps
2. **App lifecycle:** Returning to foreground
3. **After mutations:** Create/update/delete operations
4. **Initial load:** First time viewing a feature

**Related Decisions:**

- [ADR-006: Swift Data over Core Data](ADR-006-swift-data-over-core-data.md) - SwiftData as cache layer
- [ADR-011: Actor Isolation for Repository and Service Concurrency](ADR-011-actor-isolation-for-repository-concurrency.md) - Stream task management in actors
- [ADR-012: DTO-Based Data Flow](ADR-012-dto-based-data-flow.md) - DTOs flow through streams to persistence

**Notes:**

The streaming-based caching pattern provides automatic synchronization with minimal manual coordination. While it requires understanding async streams, it results in clean, reactive code where data flows naturally from network through repositories to local storage and UI.
