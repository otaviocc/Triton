# ADR-005: Adoption of Swift Observation Framework

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

After migrating services and repositories from Combine to async/await (ADR-004), the UI layer still used Combine's ObservableObject protocol with @Published properties for view-viewmodel binding. Apple introduced the Observation framework with the @Observable macro as a modern replacement.

Key considerations:

1. **Simpler syntax:** @Observable eliminates boilerplate (@Published, objectWillChange)
2. **Better performance:** Fine-grained observation tracks only accessed properties
3. **Reduced dependencies:** No need for Combine in view models
4. **Language-level support:** @Observable is a Swift macro, not a framework feature
5. **SwiftUI integration:** Native support in SwiftUI for @Observable types

**Decision:**

I migrated all view models from ObservableObject + @Published to @Observable. This completed the removal of Combine from the codebase.

**Migration Pattern:**

**Before (Combine):**
```swift
final class StatusViewModel: ObservableObject {
    @Published var statuses: [Status] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    func loadStatuses() {
        isLoading = true
        repository.fetchStatuses()
            .sink { [weak self] completion in
                self?.isLoading = false
            } receiveValue: { [weak self] statuses in
                self?.statuses = statuses
            }
            .store(in: &cancellables)
    }
}
```

**After (Observation):**
```swift
@Observable
final class StatusViewModel {
    var statuses: [Status] = []
    var isLoading = false

    func loadStatuses() async {
        isLoading = true
        defer { isLoading = false }

        do {
            statuses = try await repository.fetchStatuses()
        } catch {
            // handle error
        }
    }
}
```

**Use of @ObservationIgnored:**

Properties marked with @ObservationIgnored don't trigger view updates:
- Dependencies (repositories, services) injected via initializer
- Computed properties
- Internal state that doesn't affect UI
- Constants and configuration

**Consequences:**

### Positive

- **Less boilerplate:** No @Published, no Combine imports, no AnyCancellable storage
- **Better performance:** SwiftUI only observes accessed properties, not the entire object
- **Clearer code:** Direct property access instead of publisher chains
- **Natural async integration:** Works seamlessly with async/await in repositories
- **Compile-time safety:** @Observable provides type-safe observation
- **Removed Combine dependency:** UI layer no longer needs Combine framework

### Negative

- **Migration effort:** Requires rewriting all view models
- **Learning curve:** Understanding when to use @ObservationIgnored
- **Breaking changes:** View models are no longer ObservableObject instances

### Neutral

- **Different patterns:** Some Combine patterns (like debouncing) need alternative implementations
- **Observation scope:** Need to understand observation tracking to avoid over-observation

**Migration Strategy:**

The migration was done incrementally:

1. Started with simpler view models with fewer properties
2. Replaced ObservableObject conformance with @Observable macro
3. Removed @Published from properties
4. Converted Combine publisher chains to async/await calls
5. Removed AnyCancellable storage
6. Added @ObservationIgnored to dependencies and computed properties
7. Updated views to work with @Observable (mostly automatic)

**Related Decisions:**

- [ADR-004: Migration from Combine to Async/Await](ADR-004-migration-from-combine-to-async-await.md) - Repositories already using async/await enabled smooth integration
- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - ViewModels remain in UI layer with same responsibilities

**Notes:**

This migration completed the transition away from Combine throughout the entire codebase. The Observation framework provides a modern, performant, and simpler approach to reactive UI updates in SwiftUI.
