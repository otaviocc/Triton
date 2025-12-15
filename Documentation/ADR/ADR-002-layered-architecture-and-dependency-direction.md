# ADR-002: Layered Architecture and Dependency Direction

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When designing the OMG application, I wanted to establish clear architectural boundaries that would prevent common issues like tight coupling, circular dependencies, and difficulty testing. I needed a structure that would:

1. Separate concerns cleanly (UI, business logic, data access)
2. Make dependencies explicit and enforceable
3. Enable testing at each layer in isolation
4. Prevent accidental violations of architectural rules

**Decision:**

I adopted a strict layered architecture with enforced one-way dependency flow. The layers are:

```
         Views
           ↓
       View Models
           ↓
      Repositories
           ↓
  Network & Persistence Services
           ↓
    Shared Services (OMGAPI, SessionService, DesignSystem)
           ↓
Foundation Modules (FoundationExtensions, Utilities)
```

**Dependency Rules (Enforced):**

1. **UI → Repository (NOT → Services):** Views and ViewModels depend on Repository protocols, never directly on NetworkService or PersistenceService
2. **Repository → Services:** Repositories coordinate between NetworkService and PersistenceService layers
3. **Services → Shared Utilities:** Services depend only on infrastructure (OMGAPI, SessionService) and utilities
4. **No upward dependencies:** Lower layers cannot import higher layers
5. **Cross-cutting packages independent:** Infrastructure packages (DesignSystem, OMGAPI) do not depend on features

**Layer Responsibilities:**

- **Views (SwiftUI):** Presentation logic only, delegating actions to ViewModels
- **ViewModels (@Observable):** UI state management, coordinating user actions via Repository protocols
- **Repositories:** Domain logic, caching strategies, data coordination between network and persistence
- **NetworkService:** API communication, mapping remote payloads to DTOs (OMGAPI models)
- **PersistenceService:** Swift Data storage, local data management with domain or DTO representations
- **Shared Infrastructure:** Cross-cutting concerns (HTTP client, session management, UI components)
- **Foundation Modules:** Pure utilities with no domain knowledge

**How Dependencies are Enforced:**

SPM package dependencies in `Package.swift` files make violations impossible at compile time. For example:
- A View's package can depend on Repository but not NetworkService
- NetworkService cannot import Repository (would be rejected by SPM)
- Repositories are often `actor` types, ensuring thread-safe data operations

**Consequences:**

### Positive

- **Testability:** Each layer can be tested independently using protocol mocks/stubs
- **Compile-time safety:** Architectural violations are caught by the Swift compiler
- **Clear responsibilities:** Each layer has a well-defined purpose
- **Flexibility:** Implementations can be swapped without affecting higher layers (e.g., switching persistence strategies)
- **Reasoning:** Easy to understand where code belongs and how data flows
- **Concurrency safety:** Actor isolation at repository layer prevents data races

### Negative

- **Initial complexity:** New features require thinking about multiple layers
- **Boilerplate:** Protocol definitions and implementations add code volume
- **Cross-layer changes:** Some features require touching multiple layers sequentially

### Neutral

- **Layer granularity:** Ongoing decisions about when to introduce intermediate layers (e.g., Service layer between Repository and UI)

**Related Decisions:**

- [ADR-001: Modular Architecture with Swift Package Manager](ADR-001-modular-architecture-with-spm.md) - SPM enables enforcement
- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - How layers map to package targets
- [ADR-009: Protocol-First Repository and Service Boundaries](../Patterns/ADR-009-protocol-first-boundaries.md) - Testing and abstraction approach
- [ADR-012: DTO-Based Data Flow](../Data-Flow/ADR-012-dto-based-data-flow.md) - How data transforms across layers

**Notes:**

This strict layering was designed from the start to prevent architectural erosion over time. The one-way dependency flow ensures the codebase remains maintainable as it grows.
