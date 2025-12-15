# ADR-003: Feature-Based Package Organization

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

With a modular architecture established via Swift Package Manager, I needed to define how to organize code within each package. The key questions were:

1. What constitutes a "feature" worthy of its own package?
2. How should layers be represented within a feature package?
3. What should be public vs. private in each package?
4. How do features integrate with the main application?

**Decision:**

I adopted a feature-based package organization where each domain feature (Auth, Status, Account, PURLs, Pastebin, etc.) is a separate package with multiple internal targets representing architectural layers.

**Package Structure Pattern:**

```
FeatureName/
├── Package.swift                       # Dependencies and targets
├── Sources/
│   ├── FeatureName/                    # Main UI and app integration
│   │   ├── Views/                      # All SwiftUI views
│   │   │   ├── App/                    # Main feature view and view model
│   │   │   └── [Feature Areas]/        # Other views grouped by functionality
│   │   ├── Scenes/                     # Private window scenes (WindowGroup)
│   │   ├── Factories/                  # AppFactory with public integration methods
│   │   └── Environment/                # Feature environment and DI setup
│   ├── FeatureNameService/             # Business logic layer (optional)
│   ├── FeatureNameRepository/          # Data coordination
│   ├── FeatureNameNetworkService/      # API communication
│   └── FeatureNamePersistenceService/  # Swift Data storage
└── Tests/                              # Unit tests for each layer
```

**Public API Surface:**

Each feature package exposes a minimal public API through its `AppFactory`:

1. `makeAppView()` - Creates the main feature view for display in the sidebar
2. `makeScene()` - Returns window scenes (private to the module) as `some Scene`
3. `makeSettingsView()` - Creates settings views (when applicable)

Everything else (scenes, view models, repositories, services) remains internal to the package.

**Feature Environment:**

Each feature has its own `Environment` struct that:
- Manages a `MicroContainer` for dependency resolution
- Registers all layer factories (NetworkService, PersistenceService, Repository)
- Exposes `viewModelFactory` and `modelContainer` properties
- Is passed to scenes which use it to build views

**Feature Categories:**

- **Domain Features:** Auth, Account, Status, Now, PURLs, Webpage, Pastebin, Weblog, Pics
- **Infrastructure Packages:** OMGAPI, DesignSystem, SessionService, AuthSession, Route, Sidebar
- **Utility Packages:** FoundationExtensions, Utilities

**Integration with Main App:**

The main application (`TritonApp`) uses `TritonEnvironment` to resolve all feature factories via MicroContainer. Scenes are now private within feature modules and receive the feature `Environment` to build views.

**Consequences:**

### Positive

- **Feature isolation:** Each feature is self-contained with clear boundaries
- **Parallel development:** Features can evolve independently without conflicts
- **Selective testing:** Can test individual features without loading others
- **Clear ownership:** Each feature package owns its complete vertical slice
- **Reduced coupling:** Features cannot access each other's internals
- **Minimal public API:** Only integration points are exposed, reducing breaking changes

### Negative

- **Package proliferation:** Many packages to navigate (mitigated by clear naming)
- **Cross-feature sharing:** Shared functionality must be extracted to infrastructure packages
- **Discovery:** Finding code requires knowing which feature it belongs to

### Neutral

- **Feature granularity:** Judgment calls about feature boundaries (e.g., should PURLs and Status be one package?)
- **Shared UI components:** Decision about when to move components to DesignSystem vs. keeping them in features

**Related Decisions:**

- [ADR-001: Modular Architecture with Swift Package Manager](ADR-001-modular-architecture-with-spm.md) - Enables package-based organization
- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Layers within packages
- [ADR-010: AppFactory Pattern for Feature Integration](../Patterns/ADR-010-appfactory-pattern.md) - How features expose themselves

**Notes:**

This structure was designed from the start to support clean feature boundaries and vertical slice architecture. Each package represents a complete feature with all its layers.
