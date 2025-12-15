# ADR-011: Actor Isolation for Repository and Service Concurrency

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

With the adoption of async/await and Swift concurrency, I needed to decide how to handle thread safety and concurrent access in the service and repository layers. These layers coordinate async operations, manage streaming tasks, and may maintain internal state.

Key considerations:

1. **Thread safety:** Services and repositories may be accessed from multiple concurrent contexts
2. **Mutable state:** Streaming tasks, caches, and coordination state need protection
3. **Data races:** Swift 6 strict concurrency requires proper isolation
4. **Performance:** Don't want excessive synchronization overhead
5. **API ergonomics:** Should be easy to use with async/await

The options were:
- **No isolation:** Unsafe, would lead to data races
- **Manual locking:** Error-prone and verbose (locks, queues)
- **@MainActor:** Simple but forces all operations to main thread
- **actor:** Automatic serialization with async/await integration

**Decision:**

I chose to implement services and repositories as `actor` types. Actors provide automatic serialization of mutable state access while maintaining clean async/await APIs. This ensures thread safety without manual synchronization code.

**Implementation Pattern:**

```swift
public protocol PURLsRepositoryProtocol: Sendable {
    var purlsContainer: ModelContainer { get }
    func fetchPURLs() async throws
    func addPURL(address: String, name: String, url: String) async throws
    func deletePURL(address: String, name: String) async throws
}

actor PURLsRepository: PURLsRepositoryProtocol {
    // Actor-isolated mutable state
    private let networkService: any PURLsNetworkServiceProtocol
    private let persistenceService: any PURLsPersistenceServiceProtocol
    private var streamTask: Task<Void, Never>?

    // Nonisolated for synchronous access to immutable/Sendable values
    nonisolated var purlsContainer: ModelContainer {
        persistenceService.container
    }

    init(
        networkService: any PURLsNetworkServiceProtocol,
        persistenceService: PURLsPersistenceServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        sessionService: any SessionServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService

        Task {
            await startPURLsSync()
        }
    }

    func fetchPURLs() async throws {
        // Actor-isolated method, automatically serialized
        try await networkService.fetchPURLs(for: current)
    }

    private func startPURLsSync() {
        // Manages mutable streamTask safely within actor
        streamTask = Task { [weak self] in
            guard let self else { return }
            for await purls in networkService.purlsStream() {
                // Process stream...
            }
        }
    }
}
```

**When to Use `actor` vs `@MainActor`:**

### Use `actor` for:
- **Repositories** - Coordinate async operations, manage streaming tasks, cache data
- **NetworkServices** - Handle network requests and response processing
- **PersistenceServices** - Manage Swift Data operations and storage
- **Background coordination** - Any service that doesn't need main thread
- **Mutable state** - Types that need to protect mutable internal state

### Use `@MainActor` for:
- **ViewModels** - Need to update UI on main thread
- **View code** - SwiftUI views and their direct dependencies
- **UI coordination** - Types that only work with UI state

### Don't isolate:
- **Pure protocols** - Protocol definitions should be Sendable, not isolated
- **Immutable types** - Structs with only immutable properties
- **Stateless utilities** - Pure functions and stateless helpers

**Nonisolated Access:**

Use `nonisolated` for properties that:
- Return Sendable values (ModelContainer, etc.)
- Are computed from actor-isolated state but safe to access directly
- Need synchronous access from outside the actor

```swift
nonisolated var purlsContainer: ModelContainer {
    persistenceService.container
}
```

**Data Safety Guarantees:**

1. **Serialized access:** All actor methods execute serially, preventing data races
2. **Task management:** Internal tasks (streaming, background work) are safely managed
3. **State isolation:** Mutable state is protected within actor boundary
4. **Sendable conformance:** Protocols marked Sendable ensure safe cross-actor usage

**Performance Considerations:**

### Benefits:
- **Fine-grained concurrency:** Actors suspend rather than block
- **No lock overhead:** Runtime manages scheduling efficiently
- **Natural async:** Integrates seamlessly with async/await
- **Background execution:** Services and repositories don't block main thread

### Tradeoffs:
- **Suspension points:** Each await on actor method is a potential suspension
- **Sequential execution:** Actor methods run serially (by design for safety)
- **Actor hopping:** Calls between different actors involve context switches

**Consequences:**

### Positive

- **Automatic thread safety:** No manual locks or synchronization code
- **Data race prevention:** Compiler enforces safe concurrent access
- **Clean API:** Async/await usage feels natural
- **Mutable state protection:** Internal state safely managed
- **Swift 6 ready:** Strict concurrency checking passes
- **Off main thread:** Services and repositories don't block UI

### Negative

- **Learning curve:** Understanding actor isolation and suspension points
- **Performance characteristics:** Need to understand when suspension occurs
- **Debugging complexity:** Async context switches can complicate debugging

### Neutral

- **Actor reentrancy:** Need to be aware of reentrancy between suspension points
- **Sendable requirements:** Types crossing actor boundaries must be Sendable

**Related Decisions:**

- [ADR-004: Migration from Combine to Async/Await](ADR-004-migration-from-combine-to-async-await.md) - Actors work naturally with async/await
- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Actor isolation at service and repository layers
- [ADR-005: Adoption of Swift Observation Framework](ADR-005-adoption-of-swift-observation-framework.md) - ViewModels use @MainActor, not actor

**Notes:**

Actor isolation for services and repositories provides the right balance of thread safety and performance. It allows these layers to safely manage concurrent operations like networking, persistence, streaming, and caching while maintaining clean async/await APIs for consumers. Using actors throughout these layers ensures UI work stays on the main thread while data operations execute safely in the background.
