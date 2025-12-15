# ADR-016: SwiftUI Previews with Mother Objects

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

SwiftUI Previews enable rapid UI development by providing live visual feedback without running the full application. However, previews require:

1. **Realistic data:** Views need properly configured view models and data
2. **Dependencies:** View models depend on services, repositories, etc.
3. **Multiple states:** Need to preview different UI states (empty, loaded, error)
4. **Maintainability:** Fixture creation should be reusable and consistent
5. **Simplicity:** Previews should be easy to write

I needed a pattern for creating test fixtures that would:
- Provide realistic preview data
- Be reusable across previews and tests
- Keep preview code clean and readable
- Make it easy to create different scenarios

**Decision:**

I adopted the Mother Object pattern (https://martinfowler.com/bliki/ObjectMother.html) for creating test fixtures used in SwiftUI Previews. Mother Objects are factory classes that create fully-configured test objects with realistic data.

**Implementation Pattern:**

### Mother Object Structure

```swift
#if DEBUG

enum SidebarViewModelMother {
    @MainActor
    static func makeSidebarViewModel(
        loggedIn: Bool = false
    ) -> SidebarViewModel {
        .init(
            authSessionService: AuthSessionServiceMother.makeAuthSessionService(
                loggedIn: loggedIn
            )
        )
    }
}

#endif
```

**Key Characteristics:**

1. **DEBUG-only:** Wrapped in `#if DEBUG` to exclude from release builds
2. **Enum (no cases):** Namespace for factory methods, cannot be instantiated
3. **Static methods:** All factory methods are static
4. **Sensible defaults:** Parameters have default values for common cases
5. **Composable:** Mother Objects can call other Mother Objects
6. **@MainActor when needed:** For types requiring main thread

**Usage in Previews:**

```swift
#Preview("Logged in") {
    SidebarView(
        viewModel: SidebarViewModelMother.makeSidebarViewModel(
            loggedIn: true
        ),
        selection: .constant(.statuslog)
    )
    .frame(width: 180)
}

#Preview("Logged out") {
    SidebarView(
        viewModel: SidebarViewModelMother.makeSidebarViewModel(
            loggedIn: false
        ),
        selection: .constant(.weblog)
    )
    .frame(width: 180)
}
```

**Mother Object Patterns:**

### Service Mocks

```swift
enum AuthSessionServiceMother {
    static func makeAuthSessionService(
        loggedIn: Bool = true
    ) -> any AuthSessionServiceProtocol {
        MockAuthSessionService(isLoggedIn: loggedIn)
    }
}
```

### View Models

```swift
enum StatusViewModelMother {
    @MainActor
    static func makeStatusViewModel(
        statuses: [Status] = StatusMother.makeStatuses(),
        isLoading: Bool = false
    ) -> StatusViewModel {
        .init(
            statuses: statuses,
            isLoading: isLoading,
            repository: StatusRepositoryMother.makeRepository()
        )
    }
}
```

### Domain Models

```swift
enum StatusMother {
    static func makeStatus(
        content: String = "Test status",
        createdAt: Date = Date()
    ) -> Status {
        Status(
            id: UUID().uuidString,
            content: content,
            createdAt: createdAt
        )
    }

    static func makeStatuses(count: Int = 5) -> [Status] {
        (0..<count).map { index in
            makeStatus(content: "Test status \(index + 1)")
        }
    }
}
```

**Coverage:**

Mother Objects are used in **90% of views** for previews, providing:
- Multiple preview states per view
- Consistent test data across the application
- Easy scenario creation (empty, loading, error states)
- Reduced boilerplate in preview code

**Benefits of Mother Object Pattern:**

1. **Reusability:** Same fixtures used in previews and tests
2. **Consistency:** Uniform test data across features
3. **Readability:** Preview code is clean and intention-revealing
4. **Maintainability:** Changes to object creation centralized
5. **Discoverability:** Easy to find existing fixtures
6. **Composition:** Mother Objects build on each other

**File Organization:**

```
PackageName/
├── Sources/
│   ├── PackageName/
│   │   └── Fixtures/
│   │       ├── ViewModelMother.swift
│   │       ├── ServiceMother.swift
│   │       └── ModelMother.swift
```

**Naming Convention:**

- **File:** `{Type}Mother.swift` (e.g., `StatusViewModelMother.swift`)
- **Enum:** `{Type}Mother` (e.g., `StatusViewModelMother`)
- **Methods:** `make{Type}()` with parameters for variation

**Consequences:**

### Positive

- **Rapid development:** Fast UI iteration with live previews
- **Visual testing:** Catch UI issues immediately
- **Multiple states:** Easy to preview edge cases
- **Reduced boilerplate:** Clean, readable preview code
- **Reusable fixtures:** Same code for previews and tests
- **Documentation:** Previews serve as living documentation
- **No release bloat:** DEBUG-only code excluded from builds

### Negative

- **Maintenance:** Mother Objects need updates when APIs change
- **Discovery:** Need to know Mother Objects exist
- **Duplication:** Similar patterns across features

### Neutral

- **Pattern consistency:** Team must understand and follow pattern
- **Fixture realism:** Balance between simple and realistic data

**Integration with Testing:**

Mother Objects serve double duty:
- **Previews:** Visual development and verification
- **Unit tests:** Provide test fixtures for logic testing
- **Snapshot tests:** If implemented, use same fixtures

**Related Decisions:**

- [ADR-014: SwiftUI-First UI Development](ADR-014-swiftui-first-ui-development.md) - Previews are key to SwiftUI development
- [ADR-005: Adoption of Swift Observation Framework](ADR-005-adoption-of-swift-observation-framework.md) - @Observable view models work naturally in previews

**Notes:**

The Mother Object pattern provides a clean, reusable approach to creating test fixtures for SwiftUI Previews. By using Mother Objects in 90% of views, the codebase maintains consistent fixture creation while enabling rapid UI development. The pattern's reusability means the same fixtures support both visual development (previews) and automated testing, reducing duplication and maintenance burden.
