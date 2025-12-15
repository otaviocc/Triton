# ADR-006: Swift Data over Core Data

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

The OMG application initially used Core Data for persistence. However, as the application evolved, I realized that for a simple application with straightforward data models, Core Data's boilerplate was excessive:

- `.xcdatamodeld` files and data model editors
- `NSManagedObject` subclasses with Objective-C runtime requirements
- `NSFetchRequest` with string-based predicates
- Context management and merging complexities
- Boilerplate that outweighed the actual business logic

When Apple introduced Swift Data, it offered a modern alternative that matched the application's needs without the overhead.

**Decision:**

I migrated from Core Data to Swift Data for all persistence in the OMG application. The simpler API and reduced boilerplate were a better fit for this application's straightforward data models.

**Key Implementation Patterns:**

1. **@Model macro:** Domain models or persistence models marked with @Model
2. **ModelContainer:** Each feature's environment manages its own ModelContainer
3. **ModelContext:** Used in PersistenceService implementations for CRUD operations
4. **Actor isolation:** PersistenceService implementations often use `actor` for thread safety
5. **Query patterns:** Repository layer queries through PersistenceService protocols

**Example Structure:**

```swift
// Model definition
@Model
final class StatusEntity {
    var id: String
    var content: String
    var createdAt: Date

    init(id: String, content: String, createdAt: Date) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
    }
}

// PersistenceService usage
actor StatusPersistenceService {
    private let modelContext: ModelContext

    func fetchStatuses() async throws -> [StatusEntity] {
        let descriptor = FetchDescriptor<StatusEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
```

**Consequences:**

### Positive

- **Dramatically less boilerplate:** No .xcdatamodeld files, NSEntityDescription, or NSManagedObject subclasses
- **Type safety:** Compile-time checking instead of runtime string-based queries
- **Modern Swift:** Uses macros, property wrappers, and Swift's type system
- **Natural async:** Swift Data works seamlessly with async/await
- **Simpler relationships:** Relationships defined as regular Swift properties
- **Better fit for simple models:** Complexity matches actual needs
- **Predictable behavior:** Clearer mental model than Core Data's context management

### Negative

- **Migration effort:** Required rewriting persistence layer and data models
- **Data migration:** Had to handle Core Data to Swift Data data migration
- **Maturity:** Swift Data is newer with fewer resources than Core Data
- **Feature parity:** Some advanced Core Data features not available (not needed for this app)

### Neutral

- **Learning investment:** Different from Core Data, but simpler overall
- **Platform requirements:** Requires recent OS versions (acceptable tradeoff)

**Migration Strategy:**

The migration from Core Data to Swift Data involved:

1. Redefining models using @Model macro instead of NSManagedObject
2. Replacing NSFetchRequest with FetchDescriptor
3. Converting NSPredicate string-based queries to Swift-native predicates
4. Updating PersistenceService implementations to use ModelContext
5. Migrating existing Core Data stores to Swift Data (if needed)
6. Removing .xcdatamodeld files and Core Data stack setup

**Integration with Architecture:**

- **PersistenceService layer:** Each feature has a PersistenceService target that uses Swift Data
- **Repository coordination:** Repositories coordinate between NetworkService and PersistenceService
- **ModelContainer management:** Feature environments expose modelContainer for dependency injection
- **Actor isolation:** PersistenceService implementations use `actor` for safe concurrent access

**Related Decisions:**

- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Swift Data lives in PersistenceService layer
- [ADR-004: Migration from Combine to Async/Await](ADR-004-migration-from-combine-to-async-await.md) - Swift Data naturally supports async/await

**Notes:**

For a simple application with straightforward data models, Swift Data's reduced boilerplate was a significant improvement. The migration was worthwhile to eliminate Core Data's complexity that wasn't justified by the application's actual needs.
