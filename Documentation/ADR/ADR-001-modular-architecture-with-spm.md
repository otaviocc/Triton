# ADR-001: Modular Architecture with Swift Package Manager

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When designing the OMG application architecture, I wanted to establish a solid foundation that would support long-term maintainability and growth. I evaluated several approaches for structuring the codebase:

- **Workspace with multiple Xcode targets:** Traditional approach but requires manual dependency management
- **CocoaPods/Carthage frameworks:** Third-party dependency managers with additional tooling overhead
- **Swift Package Manager (SPM):** Native Swift solution with first-class Xcode integration

**Decision:**

I chose Swift Package Manager as the foundation for a modular architecture, organizing the codebase into discrete packages within a `Packages/` directory from the outset. Each package represents either a feature domain (Auth, Status, Account, etc.) or infrastructure concern (OMGAPI, DesignSystem, SessionService, etc.).

Key principles of this SPM-based architecture:

1. **Local packages:** All packages reside in `Packages/` directory within the repository, not as external dependencies
2. **Explicit dependencies:** Each `Package.swift` declares its dependencies, making relationships clear and enforceable
3. **Target-based layering:** Within packages, I use multiple targets (main module, Service, Repository, NetworkService, PersistenceService) to enforce layer boundaries
4. **Public API surfaces:** Packages expose only necessary APIs; internal implementation details remain private
5. **Independent testing:** Each package has its own test target, enabling isolated unit testing
6. **Shared utilities first:** Foundation packages (FoundationExtensions, Utilities) have no feature dependencies

**Consequences:**

### Positive

- **Faster incremental builds:** Xcode only rebuilds changed packages and their dependents
- **Clear dependency graph:** SPM enforces acyclic dependencies at compile time, preventing circular references
- **Better code organization:** Related code lives together in cohesive packages with clear purposes
- **Improved testability:** Individual packages can be tested in isolation without application overhead
- **Enforced architecture:** Package boundaries make it impossible to violate layering rules without explicit dependency changes
- **Native tooling:** SPM is built into Xcode and Swift, requiring no additional setup
- **Scalability:** The architecture naturally accommodates growth without major restructuring

### Negative

- **Initial setup overhead:** Creating package structure requires upfront planning before writing feature code
- **Xcode scheme proliferation:** Each package and target creates additional schemes (mitigated by hiding unnecessary schemes)
- **Cross-package refactoring:** Moving code between packages requires updating multiple `Package.swift` files
- **Build system quirks:** Occasional Xcode caching issues require clean builds or derived data deletion

### Neutral

- **Package granularity decisions:** Ongoing judgment calls about when to split or merge packages
- **Version management:** All packages version together with the main app (not independent versioning)

**Related Decisions:**

- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Defines how packages relate to each other
- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - Details package internal structure

**Notes:**

This modular approach was chosen from the beginning to establish clear boundaries and maintainability patterns from day one.
