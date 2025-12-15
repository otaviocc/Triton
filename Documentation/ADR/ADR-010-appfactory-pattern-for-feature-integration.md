# ADR-010: AppFactory Pattern for Feature Integration

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

With a modular architecture where each feature is a separate package, I needed a consistent way to integrate features into the main application. The key challenges were:

1. **Encapsulation:** Feature internals (view models, repositories, services) should remain private
2. **Dependency injection:** Features need various dependencies from the main app
3. **Multiple entry points:** Features may provide main views, scenes, and settings views
4. **SwiftUI integration:** Need to provide both views and scenes (WindowGroup, etc.)
5. **Testability:** Integration points should be mockable

**Decision:**

I adopted the AppFactory pattern where each feature package exposes a single public factory class with three standardized methods:

1. **`makeAppView()`** - Creates the main feature view for display in the sidebar or main content area
2. **`makeScene()`** - Returns window scenes (WindowGroup) private to the module
3. **`makeSettingsView()`** - Creates settings views when applicable (optional)

Factories receive dependencies via their initializer and internally manage a feature-specific Environment that handles further dependency resolution.

**Implementation Pattern:**

```swift
public final class StatusAppFactory {
    private let environment: StatusEnvironment

    public init(
        sessionService: any SessionServiceProtocol,
        authSessionService: any AuthSessionServiceProtocol,
        networkClient: NetworkClientProtocol
    ) {
        environment = .init(
            sessionService: sessionService,
            authSessionService: authSessionService,
            networkClient: networkClient
        )
    }

    @MainActor
    @ViewBuilder
    public func makeAppView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeStatusAppViewModel()

        StatusApp(viewModel: viewModel)
            .environment(\.viewModelFactory, environment.viewModelFactory)
            .modelContainer(environment.modelContainer)
    }

    @MainActor
    @ViewBuilder
    public func makeSettingsView() -> some View {
        let viewModel = environment.viewModelFactory
            .makeStatusSettingsViewModel()

        StatusSettingsView(viewModel: viewModel)
            .modelContainer(environment.modelContainer)
    }

    @MainActor
    public func makeScene() -> some Scene {
        ComposeStatusScene(environment: environment)
    }
}
```

**Integration with TritonEnvironment:**

```swift
struct TritonEnvironment: TritonEnvironmentProtocol {
    private let container = DependencyContainer()

    var statusAppFactory: StatusAppFactory { container.resolve() }

    init() {
        container.register(
            type: StatusAppFactory.self,
            allocation: .static
        ) { container in
            StatusAppFactory(
                sessionService: container.resolve(),
                authSessionService: container.resolve(),
                networkClient: container.resolve()
            )
        }
    }
}
```

**Why Factories Over Direct Instantiation:**

1. **Encapsulation:** Keeps view models, repositories, and internal dependencies private
2. **Single public interface:** Only the factory is public, everything else is internal
3. **Dependency coordination:** Factory manages complex dependency graphs internally
4. **Consistent integration:** All features integrate the same way
5. **Testability:** Can mock factories for testing main app integration
6. **Lazy initialization:** Features only initialize when actually used

**Consequences:**

### Positive

- **Clear boundaries:** Features expose minimal public API surface
- **Consistent pattern:** All features integrate identically
- **Dependency management:** Complex graphs handled internally by each feature
- **Flexibility:** Features can evolve internals without affecting main app
- **Testability:** Integration points are mockable
- **SwiftUI native:** Returns proper SwiftUI types (some View, some Scene)

### Negative

- **Boilerplate:** Each feature needs a factory class
- **Indirect access:** Can't directly instantiate feature components
- **Factory proliferation:** One factory per feature adds code

### Neutral

- **Learning curve:** Team members need to understand factory pattern
- **Factory responsibilities:** Ongoing decisions about what belongs in factory vs environment

**Method Contracts:**

- **`makeAppView()`** - REQUIRED: Must return main feature view, marked @MainActor
- **`makeScene()`** - OPTIONAL: Returns scenes for auxiliary windows, marked @MainActor
- **`makeSettingsView()`** - OPTIONAL: Returns settings view when feature has preferences, marked @MainActor

**Related Decisions:**

- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - Factories are part of feature structure
- [ADR-008: MicroContainer for Dependency Injection](ADR-008-microcontainer-for-dependency-injection.md) - Factories registered in container
- [ADR-002: Layered Architecture and Dependency Direction](ADR-002-layered-architecture-and-dependency-direction.md) - Factories are integration layer

**Notes:**

The AppFactory pattern provides a clean, consistent way to integrate modular features while maintaining strong encapsulation. It's the primary public interface for each feature package.
