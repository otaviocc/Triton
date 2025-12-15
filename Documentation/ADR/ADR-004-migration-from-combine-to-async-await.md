# ADR-004: Migration from Combine to Async/Await

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

Initially, the OMG application used Combine throughout for asynchronous operations in services and repositories. As the codebase evolved and Swift's concurrency model matured, I needed to decide whether to continue with Combine or migrate to async/await.

Key considerations:

1. **Language evolution:** Swift's native async/await became the recommended approach for asynchronous code
2. **Complexity:** Combine introduced complexity with operators, publishers, and subscriptions that weren't always necessary
3. **Learning curve:** async/await is more straightforward and easier to reason about
4. **Ecosystem shift:** Apple's frameworks increasingly favor async/await over Combine

**Decision:**

I migrated the codebase from Combine to async/await for services and repositories. The migration focused on:

1. **Service Layer:** All repository and service methods use async/await for asynchronous operations
2. **Network calls:** API requests use async/await instead of Combine publishers
3. **Data operations:** Swift Data operations naturally work with async/await

**Where Async/Await is Used:**

- Repository protocols and implementations
- NetworkService methods
- PersistenceService data operations
- ViewModel methods that coordinate async operations
- Any I/O bound operations (network, disk, etc.)

**Where Combine Still Existed After This Migration:**

- UI layer (ViewModels) continued to use Combine with @Published properties and ObservableObject
- This was later migrated separately with the adoption of Swift's Observation framework (see ADR-005)

**Consequences:**

### Positive

- **Simpler code:** Async/await reads sequentially, easier to understand than Combine chains
- **Better error handling:** Standard try/catch instead of Combine's error handling
- **Reduced boilerplate:** No need to manage Cancellables, subscriptions, or AnyCancellable sets
- **Native Swift:** Language-level support means better tooling and compiler support
- **Debugging:** Stack traces are clearer, easier to step through async code

### Negative

- **Migration effort:** Requires rewriting existing Combine-based code
- **Lost operators:** Some Combine operators (debounce, throttle) need manual implementation
- **Breaking changes:** Function signatures change from publishers to async throws

### Neutral

- **Different mental model:** Moving from reactive streams to sequential async code
- **Pattern changes:** Some reactive patterns need rethinking in async/await terms

**Migration Strategy:**

The migration was done incrementally:

1. Started with repositories and services (deepest layers)
2. Updated repository methods to return async/await instead of publishers
3. ViewModels continued using Combine to consume these async methods
4. Removed Combine imports from service and repository layers
5. UI layer migration to Observation framework happened later (see ADR-005)

**Related Decisions:**

- [ADR-005: Adoption of Swift Observation Framework](ADR-005-adoption-of-swift-observation-framework.md) - Completed the migration away from Combine in UI layer
- [ADR-006: Swift Data over Core Data](ADR-006-swift-data-over-core-data.md) - Swift Data works naturally with async/await

**Notes:**

This migration aligns with Swift's evolution and Apple's recommended patterns. Async/await provides a cleaner, more maintainable foundation for asynchronous code in services and repositories. The UI layer's transition away from Combine happened separately with the Observation framework adoption.
