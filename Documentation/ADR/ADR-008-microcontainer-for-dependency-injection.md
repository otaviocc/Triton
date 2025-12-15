# ADR-008: MicroContainer for Dependency Injection

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

With a modular architecture using multiple packages, I needed a dependency injection solution to wire up the application. The options included:

1. **Manual dependency injection:** Pass dependencies through initializers (simple but verbose)
2. **SwiftUI @Environment:** Good for view-level DI but limited to SwiftUI context
3. **Third-party DI frameworks:** Swinject, Resolver, etc. (feature-rich but complex)
4. **MicroContainer:** Lightweight DI container I built for this purpose

Key considerations:

- **Simplicity:** Needed straightforward registration and resolution
- **Type safety:** Compile-time safety where possible
- **Factory pattern support:** Factories are the primary integration pattern
- **Lifecycle management:** Support for singleton (.static) vs transient instances
- **Minimal overhead:** Lightweight solution without complex features

**Decision:**

I chose to build and use MicroContainer (exposed as `DependencyContainer`) as the dependency injection solution for the OMG application. It provides a simple, type-safe API for registering and resolving dependencies, tailored to the application's factory-based architecture.

**Key Implementation Patterns:**

1. **TritonEnvironment:** Main app environment manages root `DependencyContainer`
2. **Registration:** Dependencies registered with type, allocation strategy, and factory closure
3. **Resolution:** Simple `container.resolve()` with type inference
4. **Static allocation:** Singleton instances using `.static` allocation
5. **Dependency chains:** Container passed to factory closures for resolving dependencies

**Example Usage:**

```swift
// Main environment setup
struct TritonEnvironment: TritonEnvironmentProtocol {
    private let container = DependencyContainer()

    // Computed properties resolve from container
    var authSessionService: any AuthSessionServiceProtocol { container.resolve() }
    var statusAppFactory: StatusAppFactory { container.resolve() }

    init() {
        // Register core service with singleton allocation
        container.register(
            type: (any AuthSessionServiceProtocol).self,
            allocation: .static
        ) { _ in
            authSessionServiceFactory.makeAuthSessionService()
        }

        // Register with dependency resolution
        container.register(
            type: (any NetworkClientProtocol).self,
            allocation: .static
        ) { container in
            let authSessionService = container.resolve() as any AuthSessionServiceProtocol
            return networkClient.makeOMGAPIClient(
                authTokenProvider: {
                    await authSessionService.accessToken
                }
            )
        }

        // Register feature factory
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

**Consequences:**

### Positive

- **Simple API:** Easy to understand registration and resolution
- **Type safety:** Type-based resolution with compiler support
- **Lightweight:** Minimal overhead and complexity
- **Full control:** Can evolve alongside the application's needs
- **Factory-friendly:** Natural fit for factory-based architecture
- **Allocation control:** Explicit `.static` for singletons
- **Testability:** Easy to register mock implementations for testing

### Negative

- **Maintenance responsibility:** I maintain the library
- **Limited features:** No advanced DI features (property injection, circular dependency detection, etc.)
- **Manual registration:** Need to explicitly register all dependencies
- **No automatic cleanup:** Need to manage lifecycles manually

### Neutral

- **Learning curve:** Need to understand container patterns
- **Feature scope:** Only implements features needed by this application
- **Dependency management:** External dependency, but under my control

**Integration with Architecture:**

- **TritonEnvironment:** Root environment in main app with `DependencyContainer`
- **Registration pattern:** Init methods register all dependencies with allocation strategy
- **Resolution pattern:** Computed properties use `container.resolve()` for lazy access
- **Factory dependencies:** Factories receive resolved dependencies via initializers
- **Testing:** Test environments can register mock implementations

**Related Decisions:**

- [ADR-001: Modular Architecture with Swift Package Manager](ADR-001-modular-architecture-with-spm.md) - Container wires together modular packages
- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - Each feature's AppFactory resolved from container
- [ADR-010: AppFactory Pattern for Feature Integration](../Patterns/ADR-010-appfactory-pattern.md) - Factories use container for dependency resolution

**Notes:**

Building MicroContainer gave me a dependency injection solution that fits perfectly with the factory-based architecture. The `DependencyContainer` provides just enough DI functionality with explicit allocation control and type-safe resolution.
